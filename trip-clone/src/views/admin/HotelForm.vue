<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '../../lib/supabase'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => route.params.id !== undefined)

const loading = ref(false)
const form = ref({
  name: '',
  description: '',
  rating: 4.0,
  image_url: '',
  street: '',
  city: '',
  country: '',
  zip_code: ''
})

const allFacilities = ref([])
const selectedFacilities = ref([])

onMounted(async () => {
  loading.value = true
  try {
    // 1. Fetch all available facilities
    const { data: facilitiesData, error: facilitiesError } = await supabase
      .from('facilities')
      .select('*')
    if (facilitiesError) throw facilitiesError
    allFacilities.value = facilitiesData

    // 2. If Edit, fetch hotel data and existing facilities
    if (isEdit.value) {
      const { data, error } = await supabase
        .from('hotels')
        .select('*, address:addresses(*), facilities:hotel_facilities(facility_id), rooms(*)')
        .eq('id', route.params.id)
        .single()
      
      if (error) throw error

      form.value = {
        name: data.name,
        description: data.description,
        rating: data.rating,
        image_url: data.image_url,
        street: data.address[0]?.street || '',
        city: data.address[0]?.city || '',
        country: data.address[0]?.country || '',
        zip_code: data.address[0]?.zip_code || ''
      }

      // Set selected facilities
      selectedFacilities.value = data.facilities.map(f => f.facility_id)

      // Set rooms
      if (data.rooms) {
        rooms.value = data.rooms.map(r => ({
          ...r,
          selectedOptions: r.description ? r.description.split(', ') : []
        }))
      }
    }
  } catch (e) {
    console.error('Error fetching data:', e)
    alert('Failed to load data')
  } finally {
    loading.value = false
  }
})

const handleSubmit = async () => {
  loading.value = true
  try {
    let hotelId = route.params.id

    // 1. Upsert Hotel
    const hotelData = {
      name: form.value.name,
      description: form.value.description,
      rating: form.value.rating,
      image_url: form.value.image_url
    }

    if (isEdit.value) {
      const { error } = await supabase
        .from('hotels')
        .update(hotelData)
        .eq('id', hotelId)
      if (error) throw error
    } else {
      const { data, error } = await supabase
        .from('hotels')
        .insert(hotelData)
        .select()
        .single()
      if (error) throw error
      hotelId = data.id
    }

    // 2. Upsert Address
    let addressId = null
    if (isEdit.value) {
      const { data } = await supabase.from('addresses').select('id').eq('hotel_id', hotelId).single()
      if (data) addressId = data.id
    }

    const addressData = {
      hotel_id: hotelId,
      street: form.value.street,
      city: form.value.city,
      country: form.value.country,
      zip_code: form.value.zip_code
    }

    if (addressId) {
      await supabase.from('addresses').update(addressData).eq('id', addressId)
    } else {
      await supabase.from('addresses').insert(addressData)
    }

    // 3. Update Facilities
    // First delete all existing links for this hotel
    const { error: deleteError } = await supabase
      .from('hotel_facilities')
      .delete()
      .eq('hotel_id', hotelId)
    if (deleteError) throw deleteError

    // Then insert new links
    if (selectedFacilities.value.length > 0) {
      const facilityInserts = selectedFacilities.value.map(facilityId => ({
        hotel_id: hotelId,
        facility_id: facilityId
      }))
      
      const { error: insertError } = await supabase
        .from('hotel_facilities')
        .insert(facilityInserts)
      if (insertError) throw insertError
    }

    // 4. Update Rooms
    // We will delete all existing rooms and re-insert them for simplicity in this demo
    // In a real app, you might want to diff and update/insert/delete selectively
    if (isEdit.value) {
      const { error: deleteRoomsError } = await supabase
        .from('rooms')
        .delete()
        .eq('hotel_id', hotelId)
      if (deleteRoomsError) throw deleteRoomsError
    }

    if (rooms.value.length > 0) {
      const roomInserts = rooms.value.map(room => ({
        hotel_id: hotelId,
        name: room.name,
        description: room.selectedOptions ? room.selectedOptions.join(', ') : '',
        base_price: room.base_price,
        max_guests: room.max_guests,
        available_count: room.available_count
      }))

      const { error: insertRoomsError } = await supabase
        .from('rooms')
        .insert(roomInserts)
      if (insertRoomsError) throw insertRoomsError
    }

    alert('儲存成功！')
    router.push('/admin')

  } catch (e) {
    console.error('Error saving hotel:', e)
    alert('儲存失敗: ' + e.message)
  } finally {
    loading.value = false
  }
}

// Room Management Logic
const rooms = ref([])
const addRoom = () => {
  rooms.value.push({
    name: '',
    description: '',
    selectedOptions: [],
    base_price: 3000,
    max_guests: 2,
    available_count: 5
  })
}
const removeRoom = (index) => {
  rooms.value.splice(index, 1)
}

const roomOptions = [
  '含早餐', '含晚餐', '山景', '海景', '市景',
  '高樓層', '低樓層', '無對外窗', '無禁菸', '禁菸房'
]
</script>

<template>
  <div class="max-w-2xl mx-auto">
    <h2 class="text-2xl font-bold mb-6">{{ isEdit ? '編輯飯店' : '新增飯店' }}</h2>

    <form @submit.prevent="handleSubmit" class="bg-white shadow-md rounded-lg p-6 space-y-6">
      
      <!-- Basic Info -->
      <div class="space-y-4">
        <h3 class="text-lg font-medium border-b pb-2">基本資訊</h3>
        
        <div>
          <label class="block text-sm font-medium text-gray-700">飯店名稱</label>
          <input v-model="form.name" type="text" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">描述</label>
          <textarea v-model="form.description" rows="3" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2"></textarea>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700">評分 (0-5)</label>
            <input v-model="form.rating" type="number" step="0.1" min="0" max="5" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">圖片網址</label>
          <input v-model="form.image_url" type="url" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
        </div>
      </div>

      <!-- Facilities -->
      <div class="space-y-4">
        <h3 class="text-lg font-medium border-b pb-2">設施</h3>
        <div class="grid grid-cols-2 sm:grid-cols-3 gap-4">
          <div v-for="facility in allFacilities" :key="facility.id" class="flex items-center">
            <input 
              type="checkbox" 
              :id="facility.id" 
              :value="facility.id" 
              v-model="selectedFacilities"
              class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded"
            >
            <label :for="facility.id" class="ml-2 block text-sm text-gray-900">
              {{ facility.name }}
            </label>
          </div>
        </div>
      </div>

      <!-- Rooms -->
      <div class="space-y-4">
        <div class="flex justify-between items-center border-b pb-2">
          <h3 class="text-lg font-medium">房間管理</h3>
          <button type="button" @click="addRoom" class="text-sm text-primary hover:text-blue-700 font-medium">
            + 新增房型
          </button>
        </div>
        
        <div v-if="rooms.length === 0" class="text-gray-500 text-sm italic text-center py-4 bg-gray-50 rounded">
          尚未新增任何房型
        </div>

        <div v-for="(room, index) in rooms" :key="index" class="bg-gray-50 p-4 rounded-lg border border-gray-200 relative">
          <button type="button" @click="removeRoom(index)" class="absolute top-2 right-2 text-red-500 hover:text-red-700">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
          </button>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="md:col-span-2">
              <label class="block text-xs font-medium text-gray-700">房型名稱</label>
              <input v-model="room.name" type="text" placeholder="例如：豪華雙人房" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
            </div>
            
            <div class="md:col-span-2">
              <label class="block text-xs font-medium text-gray-700 mb-2">房型描述 (可多選)</label>
              <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-2">
                <div v-for="option in roomOptions" :key="option" class="flex items-center">
                  <input 
                    type="checkbox" 
                    :id="`room-${index}-${option}`" 
                    :value="option" 
                    v-model="room.selectedOptions"
                    class="h-3 w-3 text-primary focus:ring-primary border-gray-300 rounded"
                  >
                  <label :for="`room-${index}-${option}`" class="ml-1 block text-xs text-gray-700 cursor-pointer">
                    {{ option }}
                  </label>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-xs font-medium text-gray-700">價格 (TWD)</label>
              <input v-model="room.base_price" type="number" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
            </div>

            <div class="grid grid-cols-2 gap-2">
              <div>
                <label class="block text-xs font-medium text-gray-700">人數</label>
                <input v-model="room.max_guests" type="number" min="1" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
              </div>
              <div>
                <label class="block text-xs font-medium text-gray-700">數量</label>
                <input v-model="room.available_count" type="number" min="0" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Address -->
      <div class="space-y-4">
        <h3 class="text-lg font-medium border-b pb-2">地點</h3>
        
        <div>
          <label class="block text-sm font-medium text-gray-700">街道地址</label>
          <input v-model="form.street" type="text" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700">城市</label>
            <input v-model="form.city" type="text" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700">國家</label>
            <input v-model="form.country" type="text" required class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">郵遞區號</label>
          <input v-model="form.zip_code" type="text" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm border p-2">
        </div>
      </div>

      <div class="flex justify-end space-x-4 pt-4 border-t">
        <router-link to="/admin" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
          取消
        </router-link>
        <button type="submit" :disabled="loading" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50">
          {{ loading ? '儲存中...' : '儲存飯店' }}
        </button>
      </div>

    </form>
  </div>
</template>
