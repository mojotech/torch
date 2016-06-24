import Pikaday from 'pikaday'

window.onload = () => {
  document.querySelectorAll('select.filter-type').forEach((field) => {
    field.addEventListener('change', (e) => {
      e.target.nextElementSibling.name = e.target.value
    })
  })

  document.querySelectorAll('.datepicker').forEach((field) => {
    new Pikaday({field: field})
  })
}
