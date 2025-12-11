<script setup>
import { useRoute } from 'vue-router'
import { computed, ref, onMounted } from 'vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import { supabase } from '../lib/supabase'

const route = useRoute()
const searchType = computed(() => route.query.type || 'Hotels')
const destination = computed(() => route.query.dest || 'Anywhere')

const results = ref([])
const loading = ref(true)
const error = ref(null)

onMounted(async () => {
  try {
    const { data, error: err } = await supabase
      .from('hotels')
      .select(`
        *,
        rooms (*),
        facilities:hotel_facilities(
          facility:facilities(*)
        )
      `)
    
    if (err) throw err
    
    // Transform data to match the template structure
    results.value = data.map(hotel => ({
      ...hotel,
      address: { city: 'City Center' }, // Placeholder as address table join is complex, simplifying for now or we can join address too
      facilities: hotel.facilities.map(f => f.facility)
    }))
    
    // Fetch addresses separately or join them. Let's do a simple join fix above or just fetch addresses.
    // Actually, let's improve the query to fetch addresses too.
    const { data: hotelsWithAddress, error: addressError } = await supabase
      .from('hotels')
      .select(`
        *,
        address:addresses(*),
        rooms(*),
        facilities:hotel_facilities(
          facility:facilities(*)
        )
      `)
      
    if (addressError) throw addressError

    results.value = hotelsWithAddress.map(hotel => ({
      ...hotel,
      address: hotel.address[0] || {}, // Address is one-to-many in schema but logically one-to-one for main address
      facilities: hotel.facilities.map(f => f.facility)
    }))

  } catch (e) {
    console.error('Error fetching hotels:', e)
    error.value = e.message
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <Header />
    <main class="flex-grow max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
      <h1 class="text-3xl font-bold mb-6">
        {{ destination === 'Anywhere' ? '所有飯店' : destination + ' 的飯店' }}
      </h1>
      
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
        <!-- Sidebar Filters -->
        <div class="lg:col-span-1">
          <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <h3 class="font-bold mb-4">篩選條件</h3>
            <div class="space-y-4">
              <div>
                <h4 class="font-medium mb-2">價格範圍</h4>
                <input type="range" class="w-full" />
              </div>
              <div>
                <h4 class="font-medium mb-2">星級</h4>
                <div class="space-y-2">
                  <label class="flex items-center"><input type="checkbox" class="mr-2"> 5 星級</label>
                  <label class="flex items-center"><input type="checkbox" class="mr-2"> 4 星級</label>
                  <label class="flex items-center"><input type="checkbox" class="mr-2"> 3 星級</label>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Results List -->
        <div class="lg:col-span-3 space-y-6">
          <div v-for="hotel in results" :key="hotel.id" class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden flex flex-col sm:flex-row">
            <div class="sm:w-64 h-48 sm:h-auto">
              <img :src="hotel.image_url" :alt="hotel.name" class="w-full h-full object-cover" />
            </div>
            <div class="p-6 flex-1 flex flex-col justify-between">
              <div>
                <div class="flex justify-between items-start">
                  <h3 class="text-xl font-bold">{{ hotel.name }}</h3>
                  <span class="bg-blue-100 text-primary px-2 py-1 rounded text-sm font-bold">{{ hotel.rating }}</span>
                </div>
                <p class="text-gray-500 mt-1">{{ hotel.address.city }}</p>
                
                <!-- Facilities Preview -->
                <div class="mt-2 flex flex-wrap gap-2">
                  <span v-for="facility in hotel.facilities.slice(0, 3)" :key="facility.id" class="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded">
                    {{ facility.name }}
                  </span>
                </div>
              </div>
              
              <div class="mt-4 flex justify-between items-end">
                <div>
                  <span class="text-xs text-gray-500 block mb-1">每晚</span>
                  <span class="text-2xl font-bold text-gray-900">TWD {{ hotel.rooms[0]?.base_price }}</span>
                  <span class="text-gray-500 text-sm"> 起</span>
                </div>
                <router-link 
                  :to="{ name: 'HotelDetails', params: { id: hotel.id } }"
                  class="bg-primary text-white px-6 py-2 rounded-md font-medium hover:bg-blue-600 transition-colors inline-block text-center"
                >
                  查看空房情況
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>
