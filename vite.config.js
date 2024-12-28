import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        host: '0.0.0.0',
        port: 5173,
        hmr: {
            port: 5173,
            clientPort: 5173,
            host: 'localhost'
        },
        proxy: {
            '^/(storage|images|css|js|assets)': {
                target: 'http://localhost:61000',
                changeOrigin: true,
                secure: false,
            },
        }
    }
});