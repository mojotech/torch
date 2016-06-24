import Pikaday from 'pikaday'

window.onload = () => {
  document.querySelectorAll('.datepicker').forEach((field) => {
    new Pikaday({field: field})
  })
}
