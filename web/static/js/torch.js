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

    e.target.submit()
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
