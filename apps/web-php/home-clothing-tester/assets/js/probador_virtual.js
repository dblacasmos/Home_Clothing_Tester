let video = document.getElementById('video');                    // Elemento <video> para mostrar la cámara
let camaraSelect = document.getElementById('camara');            // Selector <select> para elegir la cámara
let prendaSelect = document.getElementById('prenda');            // Selector <select> para elegir la prenda
let previewPrenda = document.getElementById('preview-prenda');   // Imagen de la prenda seleccionada

// Listar cámaras disponibles
navigator.mediaDevices.enumerateDevices().then(devices => {
  let cams = devices.filter(device => device.kind === 'videoinput'); // Solo cámaras
  cams.forEach((cam, i) => {
    let option = document.createElement('option');  // Crea una opción <option>
    option.value = cam.deviceId;
    option.text = cam.label || `Cámara ${i + 1}`;
    camaraSelect.appendChild(option);               // Agrega opción al selector
  });
});

// Cambiar cámara
camaraSelect.onchange = () => {
  let id = camaraSelect.value;  // Obtiene el ID de la cámara seleccionada
  navigator.mediaDevices.getUserMedia({ video: { deviceId: id } }).then(stream => {
    video.srcObject = stream;   // Muestra la nueva cámara
  });
};

// Cambiar prenda
prendaSelect.onchange = () => {
  const selectedOption = prendaSelect.options[prendaSelect.selectedIndex];
  const selectedId = selectedOption.value;

  // Oculta todas las imágenes de prendas
  document.querySelectorAll('.prenda-preview').forEach(img => {
    img.style.display = 'none';
  });

  // Muestra solo la prenda seleccionada
  const imgToShow = document.getElementById(selectedId);
  if (imgToShow) {
    imgToShow.style.display = 'block';
  }
};

// Rotar vista (NO APLICABLE)
function rotarVista() {
  alert('Vista rotada (funcionalidad por implementar)');
}

// Probar prenda
function mostrarMensaje(tipo, texto) {
  const contenedor = document.getElementById('mensaje-registro');
  contenedor.textContent = texto;
  contenedor.className = `mensaje-registro ${tipo}`;
  contenedor.style.display = 'block';

  // Oculta el mensaje después de 4 segundos
  setTimeout(() => {
    contenedor.className = 'mensaje-registro oculto';
    contenedor.textContent = '';
  }, 4000);
}

function probarPrenda() {
  const selectedOption = prendaSelect.options[prendaSelect.selectedIndex];
  const id_prenda = selectedOption.value;
  const resultado = selectedOption.textContent;

  const id_usuario = window.ID_USUARIO || 0; // Se asume que se define en otro script

  // Envía los datos al servidor
  fetch('../../controllers/user/registrar_prueba_ra.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id_usuario, id_prenda, resultado })
  })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        mostrarMensaje("exito", "✅ Prenda registrada correctamente.");
      } else {
        console.error("Error al guardar:", data.error);
        mostrarMensaje("error", "❌ No se pudo registrar la prueba.");
      }
    })
    .catch(error => {
      console.error("Error de red:", error);
      mostrarMensaje("error", "❌ Error al conectar con el servidor.");
    });
}

window.addEventListener('DOMContentLoaded', () => {
  prendaSelect.dispatchEvent(new Event('change')); // Activa el cambio de prenda al cargar
});