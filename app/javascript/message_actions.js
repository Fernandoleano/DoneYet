// Message edit and delete functions
function toggleMessageMenu(messageId) {
  const menu = document.getElementById(`message-menu-${messageId}`);
  // Close all other menus first
  document.querySelectorAll('[id^="message-menu-"]').forEach(m => {
    if (m.id !== `message-menu-${messageId}`) {
      m.classList.add('hidden');
    }
  });
  menu.classList.toggle('hidden');
}

function startEdit(messageId) {
  // Hide message content and show edit form
  document.getElementById(`message-content-${messageId}`).classList.add('hidden');
  document.getElementById(`edit-form-${messageId}`).classList.remove('hidden');
  // Hide menu
  document.getElementById(`message-menu-${messageId}`).classList.add('hidden');
  // Focus on textarea
  const textarea = document.querySelector(`#edit-form-${messageId} textarea`);
  textarea.focus();
  textarea.setSelectionRange(textarea.value.length, textarea.value.length);
}

function cancelEdit(messageId) {
  // Show message content and hide edit form
  document.getElementById(`message-content-${messageId}`).classList.remove('hidden');
  document.getElementById(`edit-form-${messageId}`).classList.add('hidden');
}

// Close menus when clicking outside
document.addEventListener('click', function(event) {
  if (!event.target.closest('[onclick^="toggleMessageMenu"]') && !event.target.closest('[id^="message-menu-"]')) {
    document.querySelectorAll('[id^="message-menu-"]').forEach(menu => {
      menu.classList.add('hidden');
    });
  }
});
