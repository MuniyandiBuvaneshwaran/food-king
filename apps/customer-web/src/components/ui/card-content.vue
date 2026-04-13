<template>
  <div
    :class="['p-6 pt-0', $props.class]"
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
