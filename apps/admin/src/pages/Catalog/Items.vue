<script setup>
import { computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/ui/card.vue'
import CardContent from '@/components/ui/card-content.vue'
import CardDescription from '@/components/ui/card-description.vue'
import CardHeader from '@/components/ui/card-header.vue'
import CardTitle from '@/components/ui/card-title.vue'
import Button from '@/components/ui/button.vue'
import Badge from '@/components/ui/badge.vue'
import { Plus, Edit, Trash2 } from 'lucide-vue-next'

const store = useStore()
const items = computed(() => store.getters['items/allItems'])

onMounted(() => {
  store.dispatch('items/fetchItems')
})
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-start">
      <Button class="gap-2">
        <Plus class="h-4 w-4" />
        Add Item
      </Button>
    </div>

    <!-- Items Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-if="items.length === 0" class="col-span-full">
        <Card>
          <CardContent class="pt-6">
            <div class="text-center py-12">
              <p class="text-slate-600 mb-4">No items found</p>
              <p class="text-sm text-slate-500">Start by adding your first menu item</p>
            </div>
          </CardContent>
        </Card>
      </div>

      <Card v-for="item in items" :key="item.id" class="hover:shadow-lg transition-shadow">
        <CardHeader class="pb-3">
          <div class="flex justify-between items-start">
            <div class="flex-1">
              <CardTitle class="text-lg text-start">{{ item.name }}</CardTitle>
              <CardDescription class="mt-1 text-start">{{ item.category }}</CardDescription>
            </div>
            <Badge variant="secondary" class="ml-2">{{ item.status }}</Badge>
          </div>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <p class="text-2xl font-bold text-sky-600">₹{{ item.price }}</p>
            <p class="text-sm text-slate-600 mt-1">{{ item.description }}</p>
          </div>
          <div class="flex gap-2 pt-2">
            <Button variant="outline" size="sm" class="flex-1 gap-2">
              <Edit class="h-4 w-4" />
              Edit
            </Button>
            <Button variant="destructive" size="sm" class="flex-1 gap-2">
              <Trash2 class="h-4 w-4" />
              Delete
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  </div>
</template>
