// State management
const state = {
  currentNotebookUri: './example.xnb.html',
  currentNotebookBlob: null,
  currentMode: 'static',
  squeakRunning: false,
  isDirty: false,
  isEditing: false,
  originalHtmlContent: null,
}

// Initialization
window.onload = async function () {
  setupEventListeners()
  const params = new URLSearchParams(window.location.search)
  const notebookUri = params.get('nb') || './example.xnb.html'
  await loadNotebook(notebookUri)
  setMode('static')
}

window.addEventListener('beforeunload', (e) => {
  if (state.isDirty) {
    e.preventDefault()
    e.returnValue = ''
  }
})

// Event listeners
function setupEventListeners() {
  document.querySelectorAll('input[name="mode"]').forEach(radio => {
    radio.addEventListener('change', (e) => handleModeChange(e.target.value))
  })

  document.getElementById('fileInput').addEventListener('change', async (e) => {
    const file = e.target.files?.[0]
    if (file) {
      await openNotebookFile(file)
    }
  })

  document.getElementById('saveBtn').addEventListener('click', () => {
    downloadNotebook()
  })
}

// Mode management
async function handleModeChange(newMode) {
  const staticDiv = document.getElementById('staticContent')
  const sqContainer = document.getElementById('sqContainer')

  if (newMode === 'static') {
    staticDiv.style.display = 'block'
    sqContainer.style.display = 'none'
  } else if (newMode === 'dynamic') {
    staticDiv.style.display = 'none'
    sqContainer.style.display = 'flex'
    if (!state.squeakRunning) {
      await startSqueak()
    }
  }
  
  state.currentMode = newMode
}

function setMode(mode) {
  document.querySelector(`input[name="mode"][value="${mode}"]`).checked = true
  state.currentMode = mode
}

// Notebook loading
async function loadNotebook(uri) {
  const response = await fetch(uri)
  if (!response.ok) throw new Error('Failed to fetch notebook')

  const displayName = uri.startsWith('data:') ? uri : (uri.split('/').pop() || uri)
  document.getElementById('fileInputDisplay').textContent = displayName
  
  state.currentNotebookBlob = await response.blob()
  state.currentNotebookUri = uri
  state.isDirty = false
  state.isEditing = false

  const htmlContent = await state.currentNotebookBlob.text()
  state.originalHtmlContent = htmlContent
  const wrappedContent = wrapContentWithStyles(htmlContent)
  const staticFrame = document.getElementById('staticContent')
  staticFrame.srcdoc = wrappedContent
  staticFrame.onload = () => setupNotebookClickHandlers()
}

function wrapContentWithStyles(htmlContent) {
  const styles = '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"><style>body { margin: 0; padding: 1rem; font-size: 0.9rem; } body *, font { font-size: inherit !important; }</style>'
  
  if (htmlContent.includes('<html') || htmlContent.includes('<HTML')) {
    return htmlContent.replace(/<head>/i, '<head>' + styles)
  }
  
  return `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  ${styles}
</head>
<body>
${htmlContent}
</body>
</html>`
}

function setupNotebookClickHandlers() {
  const iframe = document.getElementById('staticContent')
  try {
    const iframeDoc = iframe.contentDocument || iframe.contentWindow.document
    
    // Setup click handlers for notebook elements
    iframeDoc.querySelectorAll('ExploratoryNotebook').forEach(element => {
      element.style.cursor = 'pointer'
      element.addEventListener('click', async (e) => {
        e.preventDefault()
        if (state.currentMode === 'dynamic') return
        
        const modal = new bootstrap.Modal(document.getElementById('viewNotebookModal'))
        modal.show()
      })
    })
    
    // Setup modal confirmation handler (only once)
    const confirmBtn = document.getElementById('confirmViewNotebook')
    if (!confirmBtn.dataset.handlerAttached) {
      confirmBtn.dataset.handlerAttached = 'true'
      confirmBtn.addEventListener('click', () => {
        document.querySelector('input[name="mode"][value="dynamic"]').click()
        bootstrap.Modal.getInstance(document.getElementById('viewNotebookModal')).hide()
        if (confetti) setTimeout(() => {
          confetti({
            particleCount: 100,
            spread: 360,
            startVelocity: 10,
            disableForReducedMotion: true,
            origin: {
              x: confirmBtn.getBoundingClientRect().left / window.innerWidth,
              y: confirmBtn.getBoundingClientRect().top / window.innerHeight,
            }
          })
        }, 0)
      })
    }
    
    // Enable editing on double-click
    iframeDoc.body.addEventListener('dblclick', () => {
      if (!state.isEditing) {
        iframeDoc.body.contentEditable = 'true'
        iframeDoc.body.style.outline = '2px dashed #0d6efd'
        state.isEditing = true
        iframeDoc.body.focus()
        iframeDoc.body.addEventListener('input', () => {
          state.isDirty = true
        }, { once: false })
      }
    })
    
    // Disable editing on blur
    iframeDoc.body.addEventListener('blur', () => {
      if (state.isEditing) {
        iframeDoc.body.contentEditable = 'false'
        iframeDoc.body.style.outline = 'none'
        state.isEditing = false
      }
    })
  } catch (err) {
    console.warn('Could not setup notebook click handlers:', err)
  }
}

// File operations
async function openNotebookFile(file) {
  if (!file.name.endsWith('.xnb.html')) {
    alert('Please select a .xnb.html file')
    return
  }

  if (state.isDirty) {
    const confirmed = confirm('You have unsaved changes. Opening a new notebook will lose them. Continue?')
    if (!confirmed) return
  }

  if (state.squeakRunning) {
    const stopped = await stopSqueak()
    if (!stopped) return
  }

  document.getElementById('fileInputDisplay').textContent = file.name

  const blob = new Blob([await file.arrayBuffer()], { type: 'text/html' })
  state.currentNotebookBlob = blob
  state.currentNotebookUri = file.name
  state.isDirty = false
  state.isEditing = false
  
  const htmlContent = await blob.text()
  state.originalHtmlContent = htmlContent
  const staticFrame = document.getElementById('staticContent')
  staticFrame.srcdoc = wrapContentWithStyles(htmlContent)
  staticFrame.onload = () => setupNotebookClickHandlers()

  if (state.currentMode === 'dynamic') {
    await startSqueak()
  }
}

function downloadNotebook() {
  let htmlToSave = state.originalHtmlContent
  
  if (state.isDirty && state.originalHtmlContent) {
    try {
      const iframe = document.getElementById('staticContent')
      const iframeDoc = iframe.contentDocument || iframe.contentWindow.document
      const bodyClone = iframeDoc.body.cloneNode(true)
      
      bodyClone.removeAttribute('contenteditable')
      bodyClone.removeAttribute('style')
      bodyClone.querySelectorAll('[style*="cursor"]').forEach(el => {
        const style = el.getAttribute('style')
        if (style) {
          const cleanedStyle = style.replace(/cursor\s*:\s*[^;]+;?/gi, '').trim()
          if (cleanedStyle) {
            el.setAttribute('style', cleanedStyle)
          } else {
            el.removeAttribute('style')
          }
        }
      })
      
      const editedBody = bodyClone.innerHTML
      const originalHasBody = /<body[^>]*>/i.test(htmlToSave)
      
      if (originalHasBody) {
        htmlToSave = htmlToSave.replace(/(<body[^>]*>)[\s\S]*(<\/body>)/i, `$1${editedBody}$2`)
      } else {
        htmlToSave = editedBody
      }
    } catch (err) {
      console.warn('Could not get edited content, using original:', err)
    }
  }
  
  if (!htmlToSave) {
    alert('No notebook to save')
    return
  }

  const blob = new Blob([htmlToSave], { type: 'text/html' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  const filename = state.currentNotebookUri.startsWith('data:') 
    ? 'notebook.xnb.html' 
    : (state.currentNotebookUri.split('/').pop() || 'notebook.xnb.html')
  
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)

  state.isDirty = false
}

// Squeak integration
async function startSqueak() {
  if (state.squeakRunning) return
  state.squeakRunning = true

  let blobToUse = state.currentNotebookBlob
  
  if (state.isDirty && state.originalHtmlContent) {
    try {
      const iframe = document.getElementById('staticContent')
      const iframeDoc = iframe.contentDocument || iframe.contentWindow.document
      const bodyClone = iframeDoc.body.cloneNode(true)
      
      bodyClone.removeAttribute('contenteditable')
      bodyClone.removeAttribute('style')
      bodyClone.querySelectorAll('[style*="cursor"]').forEach(el => {
        const style = el.getAttribute('style')
        if (style) {
          const cleanedStyle = style.replace(/cursor\s*:\s*[^;]+;?/gi, '').trim()
          if (cleanedStyle) {
            el.setAttribute('style', cleanedStyle)
          } else {
            el.removeAttribute('style')
          }
        }
      })
      
      const editedBody = bodyClone.innerHTML
      let htmlToUse = state.originalHtmlContent
      const originalHasBody = /<body[^>]*>/i.test(htmlToUse)
      
      if (originalHasBody) {
        htmlToUse = htmlToUse.replace(/(<body[^>]*>)[\s\S]*(<\/body>)/i, `$1${editedBody}$2`)
      } else {
        htmlToUse = editedBody
      }
      
      blobToUse = new Blob([htmlToUse], { type: 'text/html' })
    } catch (err) {
      console.warn('Could not get edited content, using original:', err)
    }
  }

  const blobId = 'current-notebook'
  ;(globalThis.blobs ||= {})[blobId] = blobToUse

  SqueakJS.runSqueak('xnb-demo.image', sqCanvas, {
    appName: "Exploratory Notebook",
    files: ['xnb-demo.image', 'xnb-demo.changes', 'SqueakV60.sources'],
    forceDownload: true,
    spinner: sqSpinner,
    highDPI: true,
    argv: [,, `js-blob:${blobId}`],
    onStart: (vm, display) => {
      globalThis.vm = vm
      globalThis.display = display
      globalThis.squeakJsDestroyBridge = () => {
        vm.primHandler.unloadModule('JavaScriptPlugin')
        delete vm.primHandler.builtinModules['JavaScriptPlugin']
      }
    }
  })
}

async function stopSqueak() {
  if (!state.squeakRunning) return true

  const confirmed = confirm('Stop Squeak? You may have unsaved changes.')
  if (!confirmed) return false

  if (globalThis.display) {
    globalThis.display.quitFlag = true
    await new Promise((resolve) => setTimeout(resolve, 0))
    delete globalThis.display
    delete globalThis.vm
  }

  if (globalThis.squeakJsDestroyBridge) {
    globalThis.squeakJsDestroyBridge()
    delete globalThis.squeakJsDestroyBridge
  }

  state.squeakRunning = false
  return true
}
