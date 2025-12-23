// Giphy GIF Picker
const GIPHY_API_KEY = '3Eis98Bls4z6mbgjaqpKlajJqlMAP1OV';
let currentGifSearch = '';

// Make functions global so they can be called from HTML onclick
window.searchGifs = async function(query = 'trending') {
  try {
    const endpoint = query === 'trending' 
      ? `https://api.giphy.com/v1/gifs/trending?api_key=${GIPHY_API_KEY}&limit=20`
      : `https://api.giphy.com/v1/gifs/search?api_key=${GIPHY_API_KEY}&q=${encodeURIComponent(query)}&limit=20`;
    
    const response = await fetch(endpoint);
    const data = await response.json();
    
    displayGifs(data.data);
  } catch (error) {
    console.error('Error fetching GIFs:', error);
  }
}

window.displayGifs = function(gifs) {
  const container = document.getElementById('gifGrid');
  if (!container) return;
  
  container.innerHTML = '';
  
  gifs.forEach(gif => {
    const gifElement = document.createElement('div');
    gifElement.className = 'gif-item cursor-pointer hover:opacity-80 transition';
    gifElement.innerHTML = `
      <img src="${gif.images.fixed_height_small.url}" 
           alt="${gif.title}"
           class="w-full h-24 object-cover rounded-lg"
           onclick="selectGif('${gif.images.original.url}')">
    `;
    container.appendChild(gifElement);
  });
}

window.selectGif = function(gifUrl) {
  const textarea = document.getElementById('message-input');
  if (textarea) {
    textarea.value += '\n' + gifUrl;
    closeGifModal();
    textarea.focus();
  }
}

window.openGifModal = function() {
  const modal = document.getElementById('gifModal');
  if (modal) {
    modal.classList.remove('hidden');
    searchGifs('trending'); // Load trending GIFs by default
  }
}

window.closeGifModal = function() {
  const modal = document.getElementById('gifModal');
  const searchInput = document.getElementById('gifSearchInput');
  if (modal) modal.classList.add('hidden');
  if (searchInput) searchInput.value = '';
}

window.handleGifSearch = function() {
  const searchInput = document.getElementById('gifSearchInput');
  const query = searchInput ? searchInput.value.trim() : '';
  searchGifs(query || 'trending');
}

// Debounce search
let searchTimeout;
window.debounceGifSearch = function() {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(handleGifSearch, 500);
}

// Keep existing functions
window.insertCodeSnippet = function() {
  insertCodeBlock();
}

window.insertGif = function() {
  const gifUrl = document.getElementById('gifUrl')?.value;
  if (gifUrl) {
    const textarea = document.getElementById('message-input');
    if (textarea) {
      textarea.value += '\n' + gifUrl;
      closeGifModal();
      document.getElementById('gifUrl').value = '';
      textarea.focus();
    }
  }
}
