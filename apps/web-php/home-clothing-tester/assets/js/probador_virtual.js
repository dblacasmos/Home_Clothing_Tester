/**
 * Vista Previa de Camara - Webcam Preview Handler
 * Optimized for Logitech BRIO 4K and other high-resolution cameras
 * Note: This is a simple camera preview feature, not an adaptive virtual try-on
 */

// DOM Elements
const video = document.getElementById('video');
const camaraSelect = document.getElementById('camara');
const prendaSelect = document.getElementById('prenda');
const mensajeRegistro = document.getElementById('mensaje-registro');

// Current active stream (for cleanup)
let currentStream = null;

// =============================================================================
// CAMERA MANAGEMENT
// =============================================================================

/**
 * Stop all tracks from the current stream
 * CRITICAL: Must be called before starting a new stream
 */
function stopCurrentStream() {
  if (currentStream) {
    currentStream.getTracks().forEach(track => {
      track.stop();
      console.log(`[Camera] Stopped track: ${track.kind}`);
    });
    currentStream = null;
  }
  if (video.srcObject) {
    video.srcObject = null;
  }
}

/**
 * Get optimal camera constraints with fallback strategy
 * Logitech BRIO 4K works best with 'ideal' constraints, not 'exact'
 */
function getCameraConstraints(deviceId, resolution = 'hd') {
  const resolutions = {
    '4k': { width: 3840, height: 2160, frameRate: 30 },
    'hd': { width: 1280, height: 720, frameRate: 30 },
    'sd': { width: 640, height: 480, frameRate: 30 },
    'minimal': { width: 320, height: 240, frameRate: 15 }
  };

  const res = resolutions[resolution] || resolutions.hd;

  const constraints = {
    video: {
      // Use 'exact' for deviceId to ensure correct camera
      // Use 'ideal' for resolution to allow fallback
      ...(deviceId && { deviceId: { exact: deviceId } }),
      width: { ideal: res.width, max: 1920 },    // Cap at 1080p for stability
      height: { ideal: res.height, max: 1080 },
      frameRate: { ideal: res.frameRate, max: 30 }
    },
    audio: false
  };

  return constraints;
}

/**
 * Start camera with progressive fallback strategy
 * Tries: selected device HD → selected device SD → any camera → error
 */
async function startCamera(deviceId = null) {
  console.log('[Camera] Starting camera...', deviceId ? `Device: ${deviceId}` : 'Default');

  // Always stop previous stream first
  stopCurrentStream();

  // Fallback chain: HD → SD → Minimal → Any camera
  const attempts = [
    { deviceId, resolution: 'hd', description: 'HD (720p)' },
    { deviceId, resolution: 'sd', description: 'SD (480p)' },
    { deviceId, resolution: 'minimal', description: 'Minimal (240p)' },
    { deviceId: null, resolution: 'hd', description: 'Default camera HD' },
    { deviceId: null, resolution: 'sd', description: 'Default camera SD' }
  ];

  for (const attempt of attempts) {
    // Skip redundant attempts if no specific device requested
    if (!deviceId && attempt.deviceId === null && attempt !== attempts[3]) continue;

    try {
      const constraints = getCameraConstraints(attempt.deviceId, attempt.resolution);
      console.log(`[Camera] Trying: ${attempt.description}`, constraints);

      const stream = await navigator.mediaDevices.getUserMedia(constraints);

      // Success! Set up the video
      currentStream = stream;
      video.srcObject = stream;

      // Critical: muted + playsinline for autoplay policy
      video.muted = true;
      video.playsInline = true;

      // Wait for video to be ready
      await new Promise((resolve, reject) => {
        video.onloadedmetadata = () => {
          video.play()
            .then(() => {
              console.log(`[Camera] ✅ Success with ${attempt.description}`);
              console.log(`[Camera] Actual resolution: ${video.videoWidth}x${video.videoHeight}`);
              resolve();
            })
            .catch(reject);
        };
        video.onerror = reject;

        // Timeout fallback
        setTimeout(() => reject(new Error('Video load timeout')), 5000);
      });

      // Log active track settings
      const track = stream.getVideoTracks()[0];
      if (track) {
        const settings = track.getSettings();
        console.log('[Camera] Track settings:', settings);
      }

      return true; // Success

    } catch (error) {
      console.warn(`[Camera] Failed with ${attempt.description}:`, error.name, error.message);

      // Handle specific error types
      if (error.name === 'NotAllowedError') {
        showMessage('error', '❌ Permiso de cámara denegado. Por favor, permite el acceso.');
        return false; // No point trying other options
      }

      if (error.name === 'NotFoundError') {
        console.log('[Camera] Device not found, trying next option...');
        continue;
      }

      if (error.name === 'NotReadableError') {
        showMessage('error', '❌ Cámara en uso por otra aplicación. Cierra otras apps y recarga.');
        return false;
      }

      if (error.name === 'OverconstrainedError') {
        console.log(`[Camera] Overconstrained (${error.constraint}), trying lower resolution...`);
        continue;
      }

      // For other errors, try next fallback
      continue;
    }
  }

  // All attempts failed
  console.error('[Camera] ❌ All camera initialization attempts failed');
  showMessage('error', '❌ No se pudo iniciar ninguna cámara. Verifica la conexión USB.');
  return false;
}

/**
 * Populate camera selector dropdown
 * Must be called AFTER permission is granted for labels to appear
 */
async function populateCameraSelector() {
  try {
    const devices = await navigator.mediaDevices.enumerateDevices();
    const cameras = devices.filter(d => d.kind === 'videoinput');

    // Clear existing options
    camaraSelect.innerHTML = '';

    if (cameras.length === 0) {
      const option = document.createElement('option');
      option.text = 'No se encontraron cámaras';
      option.disabled = true;
      camaraSelect.appendChild(option);
      return;
    }

    cameras.forEach((cam, index) => {
      const option = document.createElement('option');
      option.value = cam.deviceId;
      // Use label if available, otherwise generic name
      option.text = cam.label || `Cámara ${index + 1}`;

      // Highlight BRIO specifically
      if (cam.label && cam.label.toLowerCase().includes('brio')) {
        option.text += ' (4K)';
      }

      camaraSelect.appendChild(option);
    });

    console.log(`[Camera] Found ${cameras.length} camera(s)`);

  } catch (error) {
    console.error('[Camera] Failed to enumerate devices:', error);
  }
}

/**
 * Handle camera selection change
 */
async function onCameraChange() {
  const selectedDeviceId = camaraSelect.value;
  if (!selectedDeviceId) return;

  console.log('[Camera] User selected device:', selectedDeviceId);
  showMessage('', '⏳ Iniciando cámara...');

  const success = await startCamera(selectedDeviceId);
  if (success) {
    showMessage('exito', '✅ Cámara iniciada correctamente');
    // Auto-hide success message
    setTimeout(() => {
      const msg = document.getElementById('mensaje-registro');
      if (msg && msg.classList.contains('exito')) {
        msg.className = 'mensaje-registro oculto';
      }
    }, 2000);
  }
}

// =============================================================================
// PRENDA (GARMENT) MANAGEMENT
// =============================================================================

/**
 * Handle garment selection change
 */
function onPrendaChange() {
  const selectedOption = prendaSelect.options[prendaSelect.selectedIndex];
  const selectedId = selectedOption?.value;

  // Hide all garment previews
  document.querySelectorAll('.prenda-preview').forEach(img => {
    img.style.display = 'none';
  });

  // Show selected garment
  if (selectedId) {
    const imgToShow = document.getElementById(selectedId);
    if (imgToShow) {
      imgToShow.style.display = 'block';
    }
  }
}

/**
 * View selected garment (shows garment preview)
 * Note: This is NOT adaptive body-fitting, just a simple preview
 */
function probarPrenda() {
  const selectedOption = prendaSelect.options[prendaSelect.selectedIndex];
  if (!selectedOption) {
    showMessage('error', '❌ Selecciona una prenda primero');
    return;
  }

  const id_prenda = selectedOption.value;
  const resultado = selectedOption.textContent;
  const id_usuario = window.ID_USUARIO || 0;

  if (!id_usuario) {
    showMessage('error', '❌ Usuario no identificado');
    return;
  }

  // Send to server
  fetch('/controllers/user/registrar_prueba_ra.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id_usuario, id_prenda, resultado })
  })
    .then(response => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then(data => {
      if (data.success) {
        showMessage('exito', '✅ Prenda registrada correctamente.');
      } else {
        console.error('Server error:', data.error);
        showMessage('error', '❌ No se pudo registrar la prueba.');
      }
    })
    .catch(error => {
      console.error('Network error:', error);
      showMessage('error', '❌ Error al conectar con el servidor.');
    });
}

// =============================================================================
// UI HELPERS
// =============================================================================

/**
 * Show user-facing message
 */
function showMessage(type, text) {
  if (!mensajeRegistro) return;

  mensajeRegistro.textContent = text;
  mensajeRegistro.className = `mensaje-registro ${type || ''}`.trim();
  mensajeRegistro.style.display = 'block';
  mensajeRegistro.style.opacity = '1';

  // Auto-hide error/success after delay
  if (type === 'exito' || type === 'error') {
    setTimeout(() => {
      mensajeRegistro.className = 'mensaje-registro oculto';
      mensajeRegistro.textContent = '';
    }, 4000);
  }
}

// =============================================================================
// INITIALIZATION
// =============================================================================

/**
 * Initialize the camera preview system
 */
async function initProbadorVirtual() {
  console.log('[CameraPreview] Initializing...');

  // Check for mediaDevices support
  if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
    showMessage('error', '❌ Tu navegador no soporta acceso a la cámara');
    return;
  }

  // Request initial camera access (triggers permission prompt)
  // This also populates device labels in enumerateDevices
  const cameraStarted = await startCamera(null);

  if (cameraStarted) {
    // Now enumerate devices (labels will be available after permission)
    await populateCameraSelector();

    // Select current device in dropdown if possible
    if (currentStream) {
      const track = currentStream.getVideoTracks()[0];
      if (track) {
        const settings = track.getSettings();
        if (settings.deviceId) {
          camaraSelect.value = settings.deviceId;
        }
      }
    }
  }

  // Set up event listeners
  camaraSelect.addEventListener('change', onCameraChange);
  prendaSelect.addEventListener('change', onPrendaChange);

  // Initialize garment preview
  onPrendaChange();

  // Listen for device changes (camera plugged/unplugged)
  navigator.mediaDevices.addEventListener('devicechange', async () => {
    console.log('[Camera] Device change detected');
    await populateCameraSelector();
  });

  console.log('[CameraPreview] ✅ Initialization complete');
}

// Start when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initProbadorVirtual);
} else {
  initProbadorVirtual();
}

// Cleanup on page unload
window.addEventListener('beforeunload', stopCurrentStream);
