<script setup>
import { ref } from 'vue'

const isMenuOpen = ref(false)

const navLinks = [
  { name: 'App', href: '#' },
  { name: '幫助中心', href: '#' },
  { name: '我的行程', href: '#' },
]
</script>

<template>
  <header class="bg-white shadow-sm sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <div class="flex-shrink-0 flex items-center">
          <a href="#" class="text-2xl font-bold text-primary">Trip.com</a>
        </div>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center space-x-8">
          <nav class="flex space-x-6">
            <a v-for="link in navLinks" :key="link.name" :href="link.href" class="text-gray-600 hover:text-primary font-medium transition-colors">
              {{ link.name }}
            </a>
          </nav>
          <div class="flex items-center space-x-4 border-l pl-6 border-gray-200">
            <button class="text-gray-600 hover:text-primary font-medium">TWD</button>
            <button class="text-gray-600 hover:text-primary font-medium">登入</button>
            <button class="bg-primary text-white px-4 py-2 rounded-md font-medium hover:bg-blue-600 transition-colors">
              註冊
            </button>
          </div>
        </div>

        <!-- Mobile menu button -->
        <div class="md:hidden flex items-center">
          <button @click="isMenuOpen = !isMenuOpen" class="text-gray-600 hover:text-gray-900 focus:outline-none">
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path v-if="!isMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Mobile Navigation -->
    <div v-if="isMenuOpen" class="md:hidden bg-white border-t border-gray-100">
      <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
        <a v-for="link in navLinks" :key="link.name" :href="link.href" class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-primary hover:bg-gray-50">
          {{ link.name }}
        </a>
        <div class="border-t border-gray-100 pt-4 mt-4">
          <a href="#" class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-primary hover:bg-gray-50">登入</a>
          <a href="#" class="block px-3 py-2 rounded-md text-base font-medium text-primary hover:bg-gray-50">註冊</a>
        </div>
      </div>
    </div>
  </header>
</template>
