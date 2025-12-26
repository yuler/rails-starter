# TODO: only in development?

# john
john = Identity.create!(email: "john@example.com", password: "password")
Account.create_with_owner!(account: { name: "John's Account", description: "John's first account" }, owner: { name: "John Doe", identity: john })

# yuler
yuler = Identity.create!(email: "yuler@example.com", password: "password", staff: true)
Account.create_with_owner!(account: { name: "Yuler's Account", description: "Yuler's first account" }, owner: { name: "Yuler Doe", identity: yuler })
