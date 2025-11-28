async function diagnose() {
  const checked = Array.from(document.querySelectorAll('.symptom:checked'));
  const resultBox = document.getElementById('result');

  if (checked.length === 0) {
    resultBox.style.display = 'block';
    resultBox.innerHTML = '<h3>Please select at least one symptom.</h3>';
    return;
  }

  const symptomCodes = checked.map(c => c.value);

  try {
    const res = await fetch('diagnose.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ symptoms: symptomCodes })
    });

    if (!res.ok) {
      throw new Error('Server error');
    }

    const data = await res.json();

    if (!data.issues || data.issues.length === 0) {
      resultBox.style.display = 'block';
      resultBox.innerHTML = '<h3>No matching issues found in database.</h3>';
      return;
    }

    resultBox.style.display = 'block';
    resultBox.innerHTML = `
        <h3>Possible issues:</h3>
        <ul>
            ${data.issues.map(i => `<li>${i}</li>`).join('')}
        </ul>
        <p><b>We recommend booking a full diagnostic inspection.</b></p>
    `;
  } catch (err) {
    resultBox.style.display = 'block';
    resultBox.innerHTML = '<h3>Could not contact diagnostics server.</h3>';
  }
}

