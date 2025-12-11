<script setup>
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import { supabase } from "../lib/supabase";
import Header from "../components/Header.vue";
import Footer from "../components/Footer.vue";

const route = useRoute();
const hotel = ref(null);
const loading = ref(true);
const error = ref(null);

onMounted(async () => {
  try {
    const { id } = route.params;
    if (!id) throw new Error("No hotel ID provided");

    // Fetch hotel with all related data
    const { data, error: err } = await supabase
      .from("hotels")
      .select(
        `
        *,
        address:addresses(*),
        rooms(*),
        facilities:hotel_facilities(
          facility:facilities(*)
        ),
        policies(*)
      `
      )
      .eq("id", id)
      .single();

    if (err) throw err;

    // Transform data structure for easier use in template
    hotel.value = {
      ...data,
      address: data.address[0] || {},
      facilities: data.facilities.map((f) => f.facility),
      policy: data.policies[0] || {},
    };
  } catch (e) {
    console.error("Error fetching hotel details:", e);
    error.value = e.message;
  } finally {
    loading.value = false;
  }
});
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <Header />

    <main v-if="loading" class="flex-grow flex justify-center items-center">
      <div
        class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"
      ></div>
    </main>

    <main v-else-if="error" class="flex-grow flex justify-center items-center">
      <div class="text-center">
        <h2 class="text-2xl font-bold text-gray-900 mb-2">載入飯店失敗</h2>
        <p class="text-gray-600">{{ error }}</p>
      </div>
    </main>

    <main v-else class="flex-grow">
      <!-- Hero Section -->
      <div class="relative h-[400px]">
        <img
          :src="hotel.image_url"
          :alt="hotel.name"
          class="w-full h-full object-cover"
        />
        <div
          class="absolute inset-0 bg-black bg-opacity-40 flex flex-col justify-end pb-12 px-4 sm:px-6 lg:px-8"
        >
          <div class="max-w-7xl mx-auto w-full">
            <h1 class="text-4xl font-bold text-white mb-2">{{ hotel.name }}</h1>
            <div class="flex items-center text-white space-x-4">
              <span class="bg-blue-600 px-2 py-1 rounded text-sm font-bold"
                >{{ hotel.rating }} / 5</span
              >
              <span class="flex items-center">
                <svg
                  class="w-5 h-5 mr-1"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M17.657 16.657L13 21.314l-4.657-4.657a8 8 0 0111.314 0z"
                  ></path>
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
                  ></path>
                </svg>
                {{ hotel.address.street }}, {{ hotel.address.city }},
                {{ hotel.address.country }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
          <!-- Main Content -->
          <div class="lg:col-span-2 space-y-12">
            <!-- Overview -->
            <section>
              <h2 class="text-2xl font-bold mb-4">概覽</h2>
              <p class="text-gray-600 leading-relaxed">
                {{ hotel.description }}
              </p>

              <div class="mt-8">
                <h3 class="font-bold mb-4">熱門設施</h3>
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
                  <div
                    v-for="facility in hotel.facilities"
                    :key="facility.id"
                    class="flex items-center text-gray-600"
                  >
                    <span class="mr-2">✓</span>
                    {{ facility.name }}
                  </div>
                </div>
              </div>
            </section>

            <!-- Rooms -->
            <section>
              <h2 class="text-2xl font-bold mb-6">可預訂房型</h2>
              <div class="space-y-6">
                <div
                  v-for="room in hotel.rooms"
                  :key="room.id"
                  class="bg-white border border-gray-200 rounded-lg p-6 flex flex-col sm:flex-row justify-between items-center hover:shadow-md transition-shadow"
                >
                  <div class="flex flex-col sm:flex-row gap-4 flex-1">
                    <div
                      v-if="room.image_url"
                      class="w-full sm:w-48 h-32 flex-shrink-0 object-cover"
                    >
                      <img
                        :src="room.image_url"
                        :alt="room.name"
                        class="w-full h-full object-cover rounded-lg"
                      />
                    </div>
                    <div class="mb-4 sm:mb-0">
                      <h3 class="text-xl font-bold mb-2">{{ room.name }}</h3>
                      <p class="text-gray-600 mb-2">{{ room.description }}</p>
                      <div class="flex items-center text-sm text-gray-500">
                        <svg
                          class="w-4 h-4 mr-1"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                          ></path>
                        </svg>
                        最多 {{ room.max_guests }} 位房客
                      </div>
                    </div>
                  </div>
                  <div class="text-center sm:text-right">
                    <div class="text-2xl font-bold text-primary mb-2">
                      TWD {{ room.base_price }}
                    </div>
                    <button
                      class="bg-primary text-white px-6 py-2 rounded-md font-medium hover:bg-blue-600 transition-colors w-full sm:w-auto"
                    >
                      選擇房間
                    </button>
                  </div>
                </div>
              </div>
            </section>
          </div>

          <!-- Sidebar -->
          <div class="lg:col-span-1">
            <div
              class="bg-white p-6 rounded-lg shadow-sm border border-gray-200 sticky top-24"
            >
              <h3 class="font-bold text-lg mb-4">入住須知</h3>

              <div class="space-y-6">
                <div v-if="hotel.policy">
                  <h4 class="font-medium text-gray-900 mb-2">取消政策</h4>
                  <div
                    class="bg-green-50 text-green-800 p-3 rounded-md text-sm"
                  >
                    <p class="font-bold">
                      {{ hotel.policy.cancellation_name }}
                    </p>
                    <p>{{ hotel.policy.cancellation_description }}</p>
                  </div>
                </div>

                <div>
                  <h4 class="font-medium text-gray-900 mb-2">
                    入住 / 退房時間
                  </h4>
                  <div
                    class="flex justify-between text-sm text-gray-600 border-b border-gray-100 pb-2"
                  >
                    <span>入住時間</span>
                    <span>15:00 之後</span>
                  </div>
                  <div class="flex justify-between text-sm text-gray-600 pt-2">
                    <span>退房時間</span>
                    <span>11:00 之前</span>
                  </div>
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
