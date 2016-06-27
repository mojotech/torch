import Pikaday from 'pikaday'

window.onload = () => {
  /*
   * Prevent empty fields from being submitted, since this breaks Filtrex.
   */
  document.querySelector('form#filters').addEventListener('submit', function (e) {
    e.preventDefault()

    this.querySelectorAll('input').forEach((field) => {
      if (field.value === '') {
        field.disabled = true
      }
    })

    e.target.submit()
  })

  document.querySelectorAll('select.filter-type').forEach((field) => {
    field.addEventListener('change', (e) => {
      e.target.nextElementSibling.name = e.target.value
    })
  })

  document.querySelectorAll('.datepicker').forEach((field) => {
    new Pikaday({field: field})
  })
}
