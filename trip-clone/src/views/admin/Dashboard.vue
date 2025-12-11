<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../lib/supabase'

const hotels = ref([])
const loading = ref(true)

const fetchHotels = async () => {
  try {
    const { data, error } = await supabase
      .from('hotels')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    hotels.value = data
  } catch (e) {
    console.error('Error fetching hotels:', e)
  } finally {
    loading.value = false
  }
}

const deleteHotel = async (id) => {
  if (!confirm('確定要刪除這間飯店嗎？')) return

  try {
    const { error } = await supabase
      .from('hotels')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    
    // Remove from local list
    hotels.value = hotels.value.filter(h => h.id !== id)
  } catch (e) {
    console.error('Error deleting hotel:', e)
    alert('刪除失敗')
  }
}

onMounted(fetchHotels)
</script>

<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-bold text-gray-800">飯店管理</h2>
      <router-link 
        to="/admin/hotels/new" 
        class="bg-primary text-white px-4 py-2 rounded-md font-medium hover:bg-blue-600 transition-colors"
      >
        + 新增飯店
      </router-link>
    </div>

    <div v-if="loading" class="text-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
    </div>

    <div v-else class="bg-white rounded-lg shadow overflow-hidden">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">名稱</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">評分</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">建立時間</th>
            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">操作</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="hotel in hotels" :key="hotel.id">
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="flex items-center">
                <div class="h-10 w-10 flex-shrink-0">
                  <img class="h-10 w-10 rounded-full object-cover" :src="hotel.image_url" :alt="hotel.name">
                </div>
                <div class="ml-4">
                  <div class="text-sm font-medium text-gray-900">{{ hotel.name }}</div>
                </div>
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                {{ hotel.rating }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ new Date(hotel.created_at).toLocaleDateString() }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <router-link :to="`/admin/hotels/${hotel.id}/edit`" class="text-indigo-600 hover:text-indigo-900 mr-4">編輯</router-link>
              <button @click="deleteHotel(hotel.id)" class="text-red-600 hover:text-red-900">刪除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
