<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeTab = ref('飯店')
const tabs = ['飯店', '機票', '火車票', '租車', '當地體驗']

const destination = ref('')
const date = ref('')

const handleSearch = () => {
  router.push({
    name: 'SearchResults',
    query: {
      type: activeTab.value,
      dest: destination.value,
      date: date.value
    }
  })
}
</script>

<template>
  <div class="relative bg-gray-900 h-[500px]">
    <!-- Background Image -->
    <div class="absolute inset-0 overflow-hidden">
      <img src="https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2021&q=80" alt="Travel Background" class="w-full h-full object-cover opacity-60" />
    </div>

    <!-- Search Box Container -->
    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-full flex flex-col justify-center">
      <h1 class="text-4xl md:text-5xl font-bold text-white mb-8 text-center md:text-left drop-shadow-lg">
        開啟你的旅程
      </h1>

      <div class="bg-white rounded-lg shadow-xl p-2 max-w-4xl">
        <!-- Tabs -->
        <div class="flex space-x-1 border-b border-gray-200 mb-4 overflow-x-auto pb-2">
          <button 
            v-for="tab in tabs" 
            :key="tab"
            @click="activeTab = tab"
            :class="[
              'px-6 py-3 font-medium text-sm rounded-t-lg transition-colors whitespace-nowrap',
              activeTab === tab ? 'text-primary border-b-2 border-primary bg-blue-50' : 'text-gray-600 hover:text-primary hover:bg-gray-50'
            ]"
          >
            {{ tab }}
          </button>
        </div>

        <!-- Search Inputs -->
        <div class="p-4 grid grid-cols-1 md:grid-cols-12 gap-4">
          <div class="md:col-span-5">
            <label class="block text-xs font-bold text-gray-500 uppercase mb-1">
              {{ activeTab === '機票' ? '出發地 / 目的地' : '目的地' }}
            </label>
            <input 
              v-model="destination"
              type="text" 
              :placeholder="activeTab === '機票' ? '出發地 -> 目的地' : '城市、機場、地區、地標'" 
              class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none" 
            />
          </div>
          <div class="md:col-span-3">
            <label class="block text-xs font-bold text-gray-500 uppercase mb-1">日期</label>
            <input 
              v-model="date"
              type="text" 
              placeholder="選擇日期" 
              class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none" 
            />
          </div>
          <div class="md:col-span-3">
            <label class="block text-xs font-bold text-gray-500 uppercase mb-1">
              {{ activeTab === '租車' ? '車型' : '房間 & 人數' }}
            </label>
            <input 
              type="text" 
              :placeholder="activeTab === '租車' ? '經濟型, SUV...' : '1 間房, 2 位成人'" 
              class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none" 
            />
          </div>
          <div class="md:col-span-1 flex items-end">
            <button 
              @click="handleSearch"
              class="w-full bg-primary hover:bg-blue-600 text-white font-bold py-3 px-4 rounded-md transition-colors flex items-center justify-center"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
