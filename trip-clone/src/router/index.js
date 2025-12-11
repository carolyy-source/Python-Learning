import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import SearchResults from '../views/SearchResults.vue'
import HotelDetails from '../views/HotelDetails.vue'
import AdminLayout from '../views/admin/AdminLayout.vue'
import Dashboard from '../views/admin/Dashboard.vue'
import HotelForm from '../views/admin/HotelForm.vue'

const routes = [
    {
        path: '/',
        name: 'Home',
        component: Home
    },
    {
        path: '/search',
        name: 'SearchResults',
        component: SearchResults
    },
    {
        path: '/hotel/:id',
        name: 'HotelDetails',
        component: HotelDetails
    },
    {
        path: '/admin',
        component: AdminLayout,
        children: [
            {
                path: '',
                name: 'AdminDashboard',
                component: Dashboard
            },
            {
                path: 'hotels/new',
                name: 'AddHotel',
                component: HotelForm
            },
            {
                path: 'hotels/:id/edit',
                name: 'EditHotel',
                component: HotelForm
            }
        ]
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
