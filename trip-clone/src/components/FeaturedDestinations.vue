<script setup>
const destinations = [
  {
    name: "Tokyo",
    country: "Japan",
    image:
      "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    price: "$120",
  },
  {
    name: "Paris",
    country: "France",
    image:
      "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    price: "$150",
  },
  {
    name: "New York",
    country: "USA",
    image:
      "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    price: "$200",
  },
  {
    name: "London",
    country: "UK",
    image:
      "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    price: "$180",
  },
];
</script>

<template>
  <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <h2 class="text-3xl font-bold text-title mb-8">Featured Destinations</h2>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <div
        v-for="dest in destinations"
        :key="dest.name"
        class="group relative rounded-xl overflow-hidden shadow-lg cursor-pointer"
      >
        <div class="aspect-w-3 aspect-h-4 h-64">
          <img
            :src="dest.image"
            :alt="dest.name"
            class="w-full h-full object-cover transform group-hover:scale-110 transition-transform duration-300"
          />
        </div>
        <div
          class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"
        ></div>
        <div class="absolute bottom-0 left-0 p-4 text-white">
          <h3 class="text-xl font-bold">{{ dest.name }}</h3>
          <p class="text-sm opacity-90">{{ dest.country }}</p>
          <p class="mt-2 font-semibold text-accent">From {{ dest.price }}</p>
        </div>
      </div>
    </div>
  </section>
</template>
