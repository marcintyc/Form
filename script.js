const username = document.querySelector("#username");
const pass = document.querySelector("#password");
const pass2 = document.querySelector("#password2");
const email = document.querySelector("#email");
const clearBtn = document.querySelector(".clear");
const sendBtn = document.querySelector(".send");
const closeBtn = document.querySelector(".close");
const popup = document.querySelector(".popup");
// const errorp = document.querySelector(".error-text");

const showError = (input, msg) => {
	const formBox = input.parentElement;

	const errorMsg = formBox.querySelector(".error-text");
	errorMsg.textContent = msg;

	formBox.classList.add("error");
};

const clearError = (input) => {
	const formBox = input.parentElement;
	formBox.classList.remove("error");
};

const checkForm = (input) => {
	input.forEach((element) => {
		if (element.value === "") {
			showError(element, element.placeholder);
		} else {
			clearError(element);
		}
	});
};

const checkLength = (input, min) => {
	if (input.value.length < min) {
		showError(
			input,
			`${input.previousElementSibling.innerText.slice(
				0,
				-1
			)} składa się min z ${min} znaków`
		);
	}
	console.log(typeof input.previousElementSibling.innerText);
};

const checkPassword = (pass1, pass2) => {
	if (pass1.value !== pass2.value) {
		showError(pass2, `Hasła do siebie nie pasują`);
	} else {
	}
};

const checkEmail = (email) => {
	const re =
		/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

	if (re.test(email.value)) {
		clearError(email);
	} else {
		showError(email, "Niepoprawny e-mail");
	}
};


const checkErrors = ()=>{
    const allInputs = document.querySelectorAll('.form-box');
    let errorCount = 0;

    allInputs.forEach(el=>{
        if(el.classList.contains('error')){
            errorCount++;
        }
    })
    if(errorCount===0){

        popup.classList.add('show-popup')
        
    }


}



sendBtn.addEventListener("click", (e) => {
	e.preventDefault();

	checkForm([username, pass, pass2, email]);
	checkLength(username, 3);
	checkLength(pass, 8);
	checkPassword(pass, pass2);
	checkEmail(email);
    checkErrors()
});

clearBtn.addEventListener("click", (e) => {
	e.preventDefault();

	[username, pass, pass2, email].forEach((el) => {
		el.value = "";
		clearError(el);
	});
});
