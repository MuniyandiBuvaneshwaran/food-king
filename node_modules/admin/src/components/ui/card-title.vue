<template>
  <h2
    :class="[
      'text-lg font-semibold leading-none tracking-tight',
      $props.class,
    ]"
    v-bind="$attrs"
  >
    <slot />
  </h2>
</template>

<script setup>
const props = defineProps({
  class: {
    type: [String, Number, Object, Array],
    default: '',
  },
})
</script>
