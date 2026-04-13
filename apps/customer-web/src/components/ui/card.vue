<template>
  <div
    :class="[
      'rounded-xl border border-slate-200 bg-white text-slate-950 shadow-sm hover:shadow-md transition-shadow duration-200',
      $props.class,
    ]"
    v-bind="$attrs"
  >
    <slot />
  </div>
</template>

<script setup>
const props = defineProps({
  class: {
    type: [String, Number, Object, Array],
    default: '',
  },
})
</script>
