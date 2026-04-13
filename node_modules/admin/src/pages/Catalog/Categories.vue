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
import { Plus, Edit, Trash2, Package } from 'lucide-vue-next'

const store = useStore()
const categories = computed(() => store.getters['items/allCategories'])

onMounted(() => {
  store.dispatch('items/fetchCategories')
})
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-start">
      <div>
        <h1 class="text-3xl font-bold tracking-tight">Categories</h1>
      </div>
      <Button class="gap-2">
        <Plus class="h-4 w-4" />
        Add Category
      </Button>
    </div>

    <!-- Categories List -->
    <div class="space-y-3">
      <div v-if="categories.length === 0">
        <Card>
          <CardContent class="pt-6">
            <div class="text-center py-12">
              <Package class="h-12 w-12 text-slate-300 mx-auto mb-4" />
              <p class="text-slate-600 font-medium">No categories found</p>
              <p class="text-sm text-slate-500 mt-1">Create your first category to organize menu items</p>
            </div>
          </CardContent>
        </Card>
      </div>

      <Card v-for="category in categories" :key="category.id" class="hover:shadow-md transition-shadow">
        <CardHeader class="pb-3">
          <div class="flex justify-between items-start">
            <div class="flex-1">
              <CardTitle class="text-lg text-start">{{ category.name }}</CardTitle>
              <CardDescription class="mt-1 text-start">{{ category.description }}</CardDescription>
            </div>
            <Badge variant="secondary">{{ category.itemCount }} items</Badge>
          </div>
        </CardHeader>
        <CardContent>
          <div class="flex gap-2">
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
