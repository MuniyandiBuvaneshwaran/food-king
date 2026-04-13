<template>
  <p
    :class="[
      'text-sm text-slate-600',
      $props.class,
    ]"
    v-bind="$attrs"
  >
    <slot />
  </p>
</template>

<script setup>
const props = defineProps({
  class: {
    type: [String, Number, Object, Array],
    default: '',
  },
})
</script>
