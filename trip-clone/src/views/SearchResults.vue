<script setup>
import { useRoute, useRouter } from "vue-router";
import { computed, ref, onMounted, watch } from "vue";
import Header from "../components/Header.vue";
import Footer from "../components/Footer.vue";
import { supabase } from "../lib/supabase";

const route = useRoute();
const router = useRouter();
const searchType = computed(() => route.query.type || "Hotels");
const destination = computed(() => route.query.dest || "Anywhere");

// Search Form State
const searchDestination = ref(route.query.dest || "");
const searchDate = ref(route.query.date || "");

const handleSearch = () => {
  router.push({
    name: "SearchResults",
    query: {
      type: searchType.value,
      dest: searchDestination.value,
      date: searchDate.value,
    },
  });
};

const results = ref([]);
const loading = ref(true);
const error = ref(null);

const fetchHotels = async () => {
  loading.value = true;
  error.value = null;
  try {
    // Fetch all hotels with related data
    const { data: hotelsData, error: err } = await supabase.from("hotels")
      .select(`
        *,
        address:addresses(*),
        rooms(*),
        facilities:hotel_facilities(
          facility:facilities(*)
        )
      `);

    if (err) throw err;

    let filteredData = hotelsData.map((hotel) => ({
      ...hotel,
      address: hotel.address[0] || {},
      facilities: hotel.facilities.map((f) => f.facility),
    }));

    // Client-side filtering based on search criteria
    // 1. Filter by Destination (City or Hotel Name)
    if (searchDestination.value && searchDestination.value !== "Anywhere") {
      const term = searchDestination.value.toLowerCase();
      filteredData = filteredData.filter((hotel) => {
        const cityName = hotel.address.city?.toLowerCase() || "";
        const hotelName = hotel.name.toLowerCase();
        return cityName.includes(term) || hotelName.includes(term);
      });
    }

    // 2. Filter by Date (Mock implementation: just simulating a check)
    if (searchDate.value) {
      // In a real app, we would check room availability for this date
      // For now, we assume all hotels are available
    }

    results.value = filteredData;
  } catch (e) {
    console.error("Error fetching hotels:", e);
    error.value = e.message;
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchHotels();
});

// Watch for route changes to re-fetch data
watch(
  () => route.query,
  (newQuery) => {
    searchDestination.value = newQuery.dest || "";
    searchDate.value = newQuery.date || "";
    fetchHotels();
  }
);
const getStarCount = (ratingStr) => {
  if (!ratingStr) return 0;
  const map = {
    三星級: 3,
    四星級: 4,
    五星級: 5,
  };
  return map[ratingStr] || 0;
};
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <Header />
    <main class="flex-grow max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
      <!-- Search Form -->
      <div class="bg-white rounded-lg shadow-md p-4 mb-8">
        <div class="grid grid-cols-1 md:grid-cols-12 gap-4">
          <div class="md:col-span-5">
            <label class="block text-xs font-bold text-gray-500 uppercase mb-1"
              >目的地</label
            >
            <input
              v-model="searchDestination"
              type="text"
              placeholder="城市、機場、地區、地標"
              class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none"
            />
          </div>
          <div class="md:col-span-3">
            <label class="block text-xs font-bold text-gray-500 uppercase mb-1"
              >日期</label
            >
            <input
              v-model="searchDate"
              type="text"
              placeholder="選擇日期"
              class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none"
            />
          </div>
          <div class="md:col-span-3">
            <label class="block text-xs font-bold text-gray-500 uppercase mb-1"
              >房間 & 人數</label
            >
            <input
              type="text"
              placeholder="1 間房, 2 位成人"
              class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none"
            />
          </div>
          <div class="md:col-span-1 flex items-end">
            <button
              @click="handleSearch"
              class="w-full bg-primary hover:bg-blue-600 text-white font-bold py-3 px-4 rounded-md transition-colors flex items-center justify-center"
            >
              <svg
                class="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                ></path>
              </svg>
            </button>
          </div>
        </div>
      </div>

      <h1 class="text-2xl font-bold mb-6">共有 {{ results.length }} 個住宿</h1>

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
                  <label class="flex items-center"
                    ><input type="checkbox" class="mr-2" /> 5 星級</label
                  >
                  <label class="flex items-center"
                    ><input type="checkbox" class="mr-2" /> 4 星級</label
                  >
                  <label class="flex items-center"
                    ><input type="checkbox" class="mr-2" /> 3 星級</label
                  >
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Results List -->
        <div class="lg:col-span-3 space-y-6">
          <div
            v-for="hotel in results"
            :key="hotel.id"
            class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden flex flex-col sm:flex-row"
          >
            <div class="sm:w-64 h-48 sm:h-auto">
              <img
                :src="hotel.image_url"
                :alt="hotel.name"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="p-6 flex-1 flex flex-col justify-between">
              <div>
                <div class="flex justify-between items-start">
                  <h3 class="text-xl font-bold flex items-center">
                    {{ hotel.name }}
                    <div v-if="hotel.star_rating" class="flex ml-2">
                      <svg
                        v-for="n in getStarCount(hotel.star_rating)"
                        :key="n"
                        class="w-6 h-6 text-yellow-400 -ml-1"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                        xmlns="http://www.w3.org/2000/svg"
                      >
                        <path
                          d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                        ></path>
                      </svg>
                    </div>
                  </h3>

                  <div class="flex items-center gap-2">
                    <span
                      class="bg-blue-100 text-primary px-2 py-1 rounded text-sm font-bold"
                      >{{ hotel.rating }}</span
                    >
                  </div>
                </div>
                <div class="mt-1 flex items-center gap-[2px]">
                  <p class="text-gray-500">{{ hotel.address.city }}</p>
                </div>
                <!-- Facilities Preview -->
                <div class="mt-2 flex flex-wrap gap-2">
                  <span
                    v-for="facility in hotel.facilities.slice(0, 3)"
                    :key="facility.id"
                    class="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded"
                  >
                    {{ facility.name }}
                  </span>
                </div>
              </div>

              <div class="mt-4 flex justify-between items-end">
                <div>
                  <span class="text-xs text-gray-500 block mb-1">每晚</span>
                  <span class="text-2xl font-bold text-gray-900"
                    >TWD {{ hotel.rooms[0]?.base_price }}</span
                  >
                  <span class="text-gray-500 text-sm"> 起</span>
                </div>
                <div class="flex flex-col gap-2 w-48">
                  <div class="flex justify-end gap-2">
                    <button
                      class="w-1/4 aspect-square flex items-center justify-center border border-gray-300 rounded hover:bg-gray-50 text-gray-400 hover:text-red-500 transition-colors"
                      title="加入最愛"
                    >
                      <svg
                        class="w-5 h-5"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
                        ></path>
                      </svg>
                    </button>
                    <button
                      class="w-2/4 aspect-3/2 flex items-center justify-center border border-gray-300 rounded hover:bg-gray-50 text-gray-600 hover:text-primary transition-colors text-sm"
                      title="加入比較"
                    >
                      加入比較
                    </button>
                  </div>
                  <router-link
                    :to="{ name: 'HotelDetails', params: { id: hotel.id } }"
                    class="bg-primary text-white py-2 rounded-md font-medium hover:bg-blue-600 transition-colors block text-center w-full"
                  >
                    查看空房情況
                  </router-link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>
