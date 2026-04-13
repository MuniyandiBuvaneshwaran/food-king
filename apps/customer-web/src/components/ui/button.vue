<template>
  <button
    :class="[baseStyles, variantStyles, sizeStyles, className]"
    v-bind="$attrs"
  >
    <slot />
  </button>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'default',
    validator: (value) =>
      ['default', 'destructive', 'outline', 'secondary', 'ghost', 'link'].includes(value),
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg', 'icon'].includes(value),
  },
  asChild: {
    type: Boolean,
    default: false,
  },
  class: {
    type: String,
    default: '',
  },
})

const baseStyles = `
  inline-flex items-center justify-center whitespace-nowrap rounded-md 
  text-sm font-medium ring-offset-white transition-colors 
  focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-950 
  focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50
`

const variantStyles = computed(() => {
  const variants = {
    default:
      'bg-slate-900 text-slate-50 hover:bg-slate-800 active:bg-slate-900',
    destructive:
      'bg-red-500 text-slate-50 hover:bg-red-600 active:bg-red-500',
    outline:
      'border border-slate-200 bg-white hover:bg-slate-100 text-slate-900 active:bg-white',
    secondary:
      'bg-slate-100 text-slate-900 hover:bg-slate-200 active:bg-slate-100',
    ghost:
      'hover:bg-slate-100 text-slate-900 active:bg-slate-100',
    link: 'text-slate-900 underline-offset-4 hover:underline',
  }
  return variants[props.variant] || variants.default
})

const sizeStyles = computed(() => {
  const sizes = {
    sm: 'h-8 px-3 text-xs',
    md: 'h-10 px-4 py-2',
    lg: 'h-12 px-8',
    icon: 'h-10 w-10',
  }
  return sizes[props.size] || sizes.md
})

const className = computed(() => props.class)
</script>
