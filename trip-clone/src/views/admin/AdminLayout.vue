<script setup>
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex">
    <!-- Sidebar -->
    <aside class="w-64 bg-white shadow-md">
      <div class="p-6 border-b border-gray-200">
        <h1 class="text-2xl font-bold text-primary">Trip 後台管理</h1>
      </div>
      <nav class="p-4 space-y-2">
        <router-link 
          to="/admin" 
          class="block px-4 py-2 rounded-md text-gray-600 hover:bg-blue-50 hover:text-primary transition-colors"
          active-class="bg-blue-50 text-primary font-medium"
        >
          儀表板
        </router-link>
        <router-link 
          to="/" 
          class="block px-4 py-2 rounded-md text-gray-600 hover:bg-blue-50 hover:text-primary transition-colors"
        >
          返回前台
        </router-link>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-8 overflow-y-auto">
      <router-view />
    </main>
  </div>
</template>
