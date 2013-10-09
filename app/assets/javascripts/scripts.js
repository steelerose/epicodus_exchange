var maxLength=250;

function charLimit(el) {
  if (el.value.length > maxLength) return false;
  return true;
}

function characterCount(el) {
  var charCount = document.getElementById('charCount');
  if (el.value.length > maxLength) el.value = el.value.substring(0,maxLength);
  if (charCount) charCount.innerHTML = maxLength - el.value.length;
  return true;
}