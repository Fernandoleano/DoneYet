// Message formatting functions for chat composer

function insertFormatting(prefix, suffix = prefix) {
  const textarea = document.getElementById('message-input');
  const start = textarea.selectionStart;
  const end = textarea.selectionEnd;
  const selectedText = textarea.value.substring(start, end);
  const beforeText = textarea.value.substring(0, start);
  const afterText = textarea.value.substring(end);
  
  const newText = beforeText + prefix + selectedText + suffix + afterText;
  textarea.value = newText;
  
  // Set cursor position
  const newCursorPos = selectedText ? start + prefix.length + selectedText.length + suffix.length : start + prefix.length;
  textarea.setSelectionRange(newCursorPos, newCursorPos);
  textarea.focus();
}

function insertBold() {
  insertFormatting('**');
}

function insertItalic() {
  insertFormatting('*');
}

function insertStrikethrough() {
  insertFormatting('~~');
}

function insertInlineCode() {
  insertFormatting('`');
}

function insertCodeBlock() {
  const textarea = document.getElementById('message-input');
  const start = textarea.selectionStart;
  const end = textarea.selectionEnd;
  const selectedText = textarea.value.substring(start, end);
  const beforeText = textarea.value.substring(0, start);
  const afterText = textarea.value.substring(end);
  
  const codeBlock = selectedText ? `\`\`\`\n${selectedText}\n\`\`\`` : '```\n\n```';
  const newText = beforeText + codeBlock + afterText;
  textarea.value = newText;
  
  // Position cursor inside code block
  const cursorPos = selectedText ? start + 4 + selectedText.length : start + 4;
  textarea.setSelectionRange(cursorPos, cursorPos);
  textarea.focus();
}

function insertLink() {
  const textarea = document.getElementById('message-input');
  const start = textarea.selectionStart;
  const end = textarea.selectionEnd;
  const selectedText = textarea.value.substring(start, end);
  const beforeText = textarea.value.substring(0, start);
  const afterText = textarea.value.substring(end);
  
  const linkText = selectedText || 'link text';
  const link = `[${linkText}](url)`;
  const newText = beforeText + link + afterText;
  textarea.value = newText;
  
  // Select 'url' part for easy replacement
  const urlStart = start + linkText.length + 3;
  textarea.setSelectionRange(urlStart, urlStart + 3);
  textarea.focus();
}

function insertOrderedList() {
  const textarea = document.getElementById('message-input');
  const start = textarea.selectionStart;
  const beforeText = textarea.value.substring(0, start);
  const afterText = textarea.value.substring(start);
  
  const listItem = '\n1. ';
  const newText = beforeText + listItem + afterText;
  textarea.value = newText;
  
  textarea.setSelectionRange(start + listItem.length, start + listItem.length);
  textarea.focus();
}

function insertUnorderedList() {
  const textarea = document.getElementById('message-input');
  const start = textarea.selectionStart;
  const beforeText = textarea.value.substring(0, start);
  const afterText = textarea.value.substring(start);
  
  const listItem = '\n- ';
  const newText = beforeText + listItem + afterText;
  textarea.value = newText;
  
  textarea.setSelectionRange(start + listItem.length, start + listItem.length);
  textarea.focus();
}

function insertQuote() {
  const textarea = document.getElementById('message-input');
  const start = textarea.selectionStart;
  const end = textarea.selectionEnd;
  const selectedText = textarea.value.substring(start, end);
  const beforeText = textarea.value.substring(0, start);
  const afterText = textarea.value.substring(end);
  
  const quote = selectedText ? `\n> ${selectedText}` : '\n> ';
  const newText = beforeText + quote + afterText;
  textarea.value = newText;
  
  const cursorPos = start + quote.length;
  textarea.setSelectionRange(cursorPos, cursorPos);
  textarea.focus();
}

// Keep existing functions
function insertCodeSnippet() {
  insertCodeBlock();
}
