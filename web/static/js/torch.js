import Pikaday from 'pikaday'

window.onload = () => {
  const slice = Array.prototype.slice
  /*
   * Prevent empty fields from being submitted, since this breaks Filtrex.
   */

  document.querySelector('form#filters').addEventListener('submit', function (e) {
    e.preventDefault()

    slice.call(this.querySelectorAll('input, select'), 0).forEach((field) => {
      if (field.value === '') {
        field.disabled = true
      }
    })

    slice.call(this.querySelectorAll('field'), 0).forEach((field) => {
      let text = field.textContent
      let start = field.getElements('.start')[0]
      let end = field.getElements('.end')[0]

      console.log(text)
      console.log(start)
      console.log(end)

      if (start.value === '' && end.value !== '') {
        alert(`Please select a start date for the ${text} field`)
      } else if (end.value === '' && start.value !== '') {
        alert(`Please select a end at date for the ${text} field`)
      }
    })

    // e.target.submit()
  })

  slice.call(document.querySelectorAll('select.filter-type'), 0).forEach((field) => {
    field.addEventListener('change', (e) => {
      e.target.nextElementSibling.name = e.target.value
    })
  })

  slice.call(document.querySelectorAll('.datepicker'), 0).forEach((field) => {
    new Pikaday({field: field})
  })
}
