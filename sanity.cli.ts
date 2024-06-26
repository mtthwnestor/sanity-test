import {defineCliConfig} from 'sanity/cli'

export default defineCliConfig({
  api: {
    projectId: 's94j2f6x',
    dataset: 'production'
  },
  vite: {
    server: {
      watch: {
        usePolling: true,
      },
    },
  },
})
