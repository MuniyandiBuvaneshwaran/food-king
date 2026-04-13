import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import { createStoreInstance } from './store/store'

const app = createApp(App)
const store = createStoreInstance()

app.use(store)
app.use(router)

app.mount('#app')
