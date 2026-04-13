<script setup>
import { onMounted } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/ui/card.vue'
import CardContent from '@/components/ui/card-content.vue'
import CardDescription from '@/components/ui/card-description.vue'
import CardHeader from '@/components/ui/card-header.vue'
import CardTitle from '@/components/ui/card-title.vue'
import Button from '@/components/ui/button.vue'
import Input from '@/components/ui/input.vue'
import { Save } from 'lucide-vue-next'

const store = useStore()

onMounted(() => {
  store.dispatch('settings/fetchSettings')
})
</script>

<template>
  <div class="space-y-6">
    <!-- Settings Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Company Settings -->
      <Card>
        <CardHeader>
          <CardTitle class="text-start">Company Information</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-2 text-start">Company Name</label>
            <Input type="text" placeholder="FoodKing" />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 text-start">Email Address</label>
            <Input type="email" placeholder="contact@foodking.com" />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 text-start">Phone Number</label>
            <Input type="tel" placeholder="+91 XXXXX XXXXX" />
          </div>
          <Button class="w-full gap-2 my-4">
            <Save class="h-4 w-4" />
            Save Changes
          </Button>
        </CardContent>
      </Card>

      <!-- Payment Settings -->
      <Card>
        <CardHeader>
          <CardTitle class="text-start">Payment Gateway</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-2 text-start">Payment Provider</label>
            <select class="w-full px-3 py-2 border border-slate-200 rounded-md focus:outline-none focus:ring-2 focus:ring-slate-950">
              <option>Stripe</option>
              <option>PayPal</option>
              <option>Razorpay</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 my-4 text-start">API Key</label>
            <Input type="password" placeholder="••••••••••••" />
          </div>
          <Button class="w-full gap-2 my-4">
            <Save class="h-4 w-4" />
            Save Changes
          </Button>
        </CardContent>
      </Card>

      <!-- Notification Settings -->
      <Card>
        <CardHeader>
          <CardTitle class="text-start">Notifications</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div class="flex items-center gap-3">
            <input
              type="checkbox"
              id="email-notif"
              class="rounded border-slate-200 text-slate-950 m-2"
              checked
            />
            <label for="email-notif" class="text-sm font-medium cursor-pointer">
              Email notifications
            </label>
          </div>
          <div class="flex items-center gap-3">
            <input
              type="checkbox"
              id="sms-notif"
              class="rounded border-slate-200 text-slate-950 m-2"
            />
            <label for="sms-notif" class="text-sm font-medium cursor-pointer">
              SMS notifications
            </label>
          </div>
          <div class="flex items-center gap-3">
            <input
              type="checkbox"
              id="push-notif"
              class="rounded border-slate-200 text-slate-950 m-2"
              checked
            />
            <label for="push-notif" class="text-sm font-medium cursor-pointer">
              Push notifications
            </label>
          </div>
          <Button variant="secondary" class="w-full gap-2 my-4">
            Update Preferences
          </Button>
        </CardContent>
      </Card>

      <!-- System Settings -->
      <Card>
        <CardHeader>
          <CardTitle class="text-start">System Settings</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-2 text-start">Theme</label>
            <select class="w-full px-3 py-2 border border-slate-200 rounded-md focus:outline-none focus:ring-2 focus:ring-slate-950">
              <option>Light</option>
              <option>Dark</option>
              <option>Auto</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 text-start my-4">Language</label>
            <select class="w-full px-3 py-2 border border-slate-200 rounded-md focus:outline-none focus:ring-2 focus:ring-slate-950">
              <option>English</option>
              <option>Hindi</option>
              <option>Spanish</option>
            </select>
          </div>
          <Button variant="secondary" class="w-full gap-2 my-4">
            Save Preferences
          </Button>
        </CardContent>
      </Card>
    </div>
  </div>
</template>

<style scoped>
:root {
  --primary: var(--primary);
}
</style>
