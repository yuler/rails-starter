# Solo Account Mode Implementation

为 rails-starter 项目添加 Solo（个人）账户模式，参考 Jumpstart Rails 的实现方式。

## 背景

当前系统基于 URL 路径（如 `/abc123/~/`）来区分不同的 Account。Issue #152 要求添加 Solo 模式：

- **Solo 账户**：用户注册时自动创建的个人账户，不允许邀请其他用户
- **Team 账户**：用户之后创建的团队账户，允许邀请其他成员

## 设计决策

> **保留现有功能**：URL-based 的账户中间件 (`AccountSlug::Extractor`) 将完整保留，Solo 账户只是在此基础上添加默认账户的概念。

> **懒加载创建**：用户首次需要账户时（访问需要账户的页面）才创建个人账户，而不是注册时立即创建。这样可以避免产生大量不活跃的账户。

---

## 变更内容

### Database Schema

#### [NEW] db/migrate/YYYYMMDDHHMMSS_add_personal_account_support.rb

添加支持 Solo 账户模式所需的数据库字段：

```ruby
class AddPersonalAccountSupport < ActiveRecord::Migration[8.2]
  def change
    # 标记账户是否为个人账户
    add_column :accounts, :personal, :boolean, default: false, null: false
    add_index :accounts, :personal

    # 每个 Identity 关联一个个人账户
    add_reference :identities, :personal_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
```

---

### Account Model

#### [MODIFY] app/models/account.rb

添加 Solo 账户相关方法和验证：

```diff
 class Account < ApplicationRecord
   has_many :users, dependent: :destroy
   has_many :invitations, class_name: "Account::Invitation", dependent: :destroy
+  has_one :owner_identity, class_name: "Identity", foreign_key: :personal_account_id
   has_one_attached :logo

   validates :name, presence: true

+  scope :personal, -> { where(personal: true) }
+  scope :team, -> { where(personal: false) }
+
+  # 检查是否为个人账户
+  def personal?
+    personal
+  end
+
+  # 检查是否为团队账户
+  def team?
+    !personal?
+  end
+
   # ... existing code ...
 end
```

---

### Identity Model

#### [MODIFY] app/models/identity.rb

添加个人账户关联和懒加载创建逻辑：

```diff
 class Identity < ApplicationRecord
   has_many :magic_links, dependent: :destroy
   has_many :sessions, dependent: :destroy
   has_many :users, dependent: :nullify
   has_many :accounts, through: :users
+  belongs_to :personal_account, class_name: "Account", optional: true

   # ... existing code ...

+  # 获取或创建个人账户（懒加载）
+  def ensure_personal_account!
+    return personal_account if personal_account.present?
+
+    create_personal_account!
+  end
+
+  private
+    def create_personal_account!
+      Account.transaction do
+        account = Account.create!(
+          name: "#{full_name}'s Personal Account",
+          personal: true
+        )
+        account.users.create!(role: :system, name: "System")
+        account.users.create!(
+          role: :owner,
+          name: full_name,
+          identity: self,
+          verified_at: Time.current
+        )
+        update!(personal_account: account)
+        account
+      end
+    end
 end
```

---

### Authentication Concern

#### [MODIFY] app/controllers/concerns/authentication.rb

更新 `require_account` 方法支持 Solo 模式自动跳转：

```diff
     def require_account
       if !Current.account.present?
-        redirect_to main_app.session_accounts_url(script_name: nil)
+        # Solo 模式：如果用户已登录且有个人账户，自动切换到个人账户
+        if authenticated? && Current.identity.personal_account.present?
+          redirect_to root_url(script_name: Current.identity.personal_account.slug_path)
+        elsif authenticated?
+          # 懒加载创建个人账户
+          personal_account = Current.identity.ensure_personal_account!
+          redirect_to root_url(script_name: personal_account.slug_path)
+        else
+          redirect_to main_app.session_accounts_url(script_name: nil)
+        end
       end
     end
```

---

### Sessions Accounts Controller

#### [MODIFY] app/controllers/sessions/accounts_controller.rb

更新账户列表页面，确保包含个人账户：

```diff
   def index
     @accounts = Current.identity.accounts
+    @personal_account = Current.identity.personal_account

     # TODO:
     # if @accounts.one?
     #   redirect_to root_url(script_name: @accounts.first.slug_path)
     # end
   end
```

---

### Configuration (Optional)

#### [NEW] config/initializers/solo_account.rb

添加配置选项控制 Solo 模式行为：

```ruby
# Solo Account Configuration
#
# When enabled, users will automatically get a personal account
# created on their first authenticated request that requires an account.
#
# Set to false to use team-only mode where users must create accounts manually.
Rails.application.config.solo_account_enabled = true
```

---

## 验证方案

### 自动化测试

1. **运行现有测试确保无破坏性变更**：
   ```bash
   bin/rails test
   ```

2. **数据库迁移测试**：
   ```bash
   bin/rails db:migrate
   bin/rails db:rollback
   bin/rails db:migrate
   ```

### 手动验证

1. **新用户注册流程**：
   - 注册新用户
   - 验证访问需要账户的页面时自动创建个人账户
   - 验证自动跳转到个人账户

2. **账户切换**：
   - 在个人账户和团队账户之间切换
   - 验证 URL 路径正确变化

3. **团队账户创建**：
   - 创建新的团队账户
   - 验证 `personal: false` 正确设置

4. **现有功能验证**：
   - URL-based 账户路由仍然正常工作
   - 账户邀请功能正常
