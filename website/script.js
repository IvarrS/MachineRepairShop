function diagnose() {
    const symptoms = document.querySelectorAll(".symptom:checked");
    const resultBox = document.getElementById("result");

    if (symptoms.length === 0) {
        resultBox.style.display = "block";
        resultBox.innerHTML = "<h3>Please select at least one symptom.</h3>";
        return;
    }

    let issues = [];

    symptoms.forEach(symptom => {
        switch(symptom.value) {
            case "engine_knock":
                issues.push("Possible engine detonation • Low-quality fuel • Worn bearings");
                break;

            case "warning_light":
                issues.push("ECU error • Sensor failure • Battery/alternator issue");
                break;

            case "hard_start":
                issues.push("Weak battery • Starter motor • Fuel pump problems");
                break;

            case "vibrations":
                issues.push("Wheel balance • Suspension wear • Engine mounts");
                break;

            case "overheating":
                issues.push("Coolant leak • Bad radiator fan • Thermostat malfunction");
                break;

            case "brake_noise":
                issues.push("Worn brake pads • Damaged rotors • Low brake fluid");
                break;
        }
    });

    resultBox.style.display = "block";

    resultBox.innerHTML = `
        <h3>Possible issues:</h3>
        <ul>
            ${issues.map(i => `<li>${i}</li>`).join("")}
        </ul>
        <p><b>We recommend booking a full diagnostic inspection.</b></p>
    `;
}
