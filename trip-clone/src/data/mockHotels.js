export const hotels = [
    {
        id: 'h1',
        name: 'Grand Hotel',
        description: 'Experience luxury in the heart of the city. Our Grand Hotel offers breathtaking views, exquisite dining, and world-class amenities.',
        rating: 4.5,
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        address: {
            street: '123 Main St',
            city: 'City Center',
            country: 'USA',
            zipCode: '10001'
        },
        facilities: [
            { id: 'f1', name: 'Free WiFi', icon: 'wifi' },
            { id: 'f2', name: 'Swimming Pool', icon: 'pool' },
            { id: 'f3', name: 'Fitness Center', icon: 'dumbbell' },
            { id: 'f4', name: 'Spa', icon: 'spa' }
        ],
        policies: {
            cancellation: {
                name: 'Free Cancellation',
                description: 'Cancel up to 24 hours before check-in for a full refund.',
                refundPercent: 100,
                hoursDeadline: 24
            }
        },
        rooms: [
            {
                id: 'r1',
                name: 'Deluxe King Room',
                description: 'Spacious room with a king-size bed and city view.',
                maxGuests: 2,
                basePrice: 120,
                available: 5
            },
            {
                id: 'r2',
                name: 'Executive Suite',
                description: 'Luxury suite with separate living area and premium amenities.',
                maxGuests: 3,
                basePrice: 250,
                available: 2
            }
        ]
    },
    {
        id: 'h2',
        name: 'Cozy Apartment',
        description: 'A charming apartment in a quiet suburban neighborhood. Perfect for families or long stays.',
        rating: 4.2,
        image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        address: {
            street: '456 Oak Ln',
            city: 'Suburbs',
            country: 'USA',
            zipCode: '10002'
        },
        facilities: [
            { id: 'f1', name: 'Free WiFi', icon: 'wifi' },
            { id: 'f5', name: 'Kitchen', icon: 'kitchen' },
            { id: 'f6', name: 'Parking', icon: 'parking' }
        ],
        policies: {
            cancellation: {
                name: 'Moderate',
                description: 'Cancel up to 5 days before check-in for a full refund.',
                refundPercent: 100,
                hoursDeadline: 120
            }
        },
        rooms: [
            {
                id: 'r3',
                name: 'Entire Apartment',
                description: '2 bedrooms, 1 bath, full kitchen.',
                maxGuests: 4,
                basePrice: 80,
                available: 1
            }
        ]
    },
    {
        id: 'h3',
        name: 'Luxury Resort',
        description: 'Escape to paradise at our beachfront resort. All-inclusive packages available.',
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        address: {
            street: '789 Beach Blvd',
            city: 'Beachfront',
            country: 'USA',
            zipCode: '10003'
        },
        facilities: [
            { id: 'f1', name: 'Free WiFi', icon: 'wifi' },
            { id: 'f2', name: 'Swimming Pool', icon: 'pool' },
            { id: 'f4', name: 'Spa', icon: 'spa' },
            { id: 'f7', name: 'Private Beach', icon: 'umbrella' },
            { id: 'f8', name: 'Bar', icon: 'wine-glass' }
        ],
        policies: {
            cancellation: {
                name: 'Non-Refundable',
                description: 'No refund upon cancellation.',
                refundPercent: 0,
                hoursDeadline: 0
            }
        },
        rooms: [
            {
                id: 'r4',
                name: 'Ocean View Villa',
                description: 'Private villa with direct beach access.',
                maxGuests: 2,
                basePrice: 350,
                available: 3
            },
            {
                id: 'r5',
                name: 'Garden Suite',
                description: 'Peaceful suite surrounded by tropical gardens.',
                maxGuests: 2,
                basePrice: 280,
                available: 4
            }
        ]
    }
]
