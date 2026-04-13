<template>
  <span
    :class="[baseStyles, variantStyles, className]"
    v-bind="$attrs"
  >
    <slot />
  </span>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'default',
    validator: (value) =>
      ['default', 'secondary', 'destructive', 'outline'].includes(value),
  },
  class: {
    type: String,
    default: '',
  },
})

const baseStyles = 'inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold transition-colors'

const variantStyles = computed(() => {
  const variants = {
    default:
      'border-transparent bg-slate-900 text-slate-50 hover:bg-slate-800',
    secondary:
      'border-transparent bg-slate-100 text-slate-900 hover:bg-slate-200',
    destructive:
      'border-transparent bg-red-500 text-slate-50 hover:bg-red-600',
    outline:
      'text-slate-950 border border-slate-200',
  }
  return variants[props.variant] || variants.default
})
</script>
