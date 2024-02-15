// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { delay } from "./helpers/timing_helpers.js"

!(async function () {
  await delay(1000)
  console.log('delayed 1s')
  await delay(1000)
  console.log('delayed 1s')
  await delay(1000)
  console.log('delayed 1s')
}())

navigator.serviceWorker.register('/service-worker.js')

navigator.serviceWorker.ready.then(async (serviceWorkerRegistration) => {
  serviceWorkerRegistration.pushManager
    .subscribe({
      userVisibleOnly: true,
      applicationServerKey: document.querySelector('meta[name="vapid-public-key"]').content
    });

  const subscription = await serviceWorkerRegistration.pushManager.getSubscription()
  const { endpoint, keys: { p256dh, auth } } = subscription.toJSON()
  const jsonString = JSON.stringify({ push_subscription: { endpoint, p256dh_key: p256dh, auth_key: auth } })
  console.log(jsonString)
});