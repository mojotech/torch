import Pikaday from 'pikaday'

// Phoenix html copied here since I ran into extensive issues trying to import
// from the dep.
;(function () {
  function buildHiddenInput (name, value) {
    var input = document.createElement('input')
    input.type = 'hidden'
    input.name = name
    input.value = value
    return input
  }

  function handleLinkClick (link) {
    var message = link.getAttribute('data-confirm')
    if (message && !window.confirm(message)) {
      return
    }

    var to = link.getAttribute('data-to'),
      method = buildHiddenInput('_method', link.getAttribute('data-method')),
      csrf = buildHiddenInput('_csrf_token', link.getAttribute('data-csrf')),
      form = document.createElement('form')

    form.method = (link.getAttribute('data-method') === 'get') ? 'get' : 'post'
    form.action = to
    form.style.display = 'hidden'

    form.appendChild(csrf)
    form.appendChild(method)
    document.body.appendChild(form)
    form.submit()
  }

  window.addEventListener('click', function (e) {
    var element = e.target

    while (element && element.getAttribute) {
      if (element.getAttribute('data-method')) {
        handleLinkClick(element)
        e.preventDefault()
        return false
      } else {
        element = element.parentNode
      }
    }
  }, false)
})()

window.onload = () => {
  const slice = Array.prototype.slice

  /*
   * Set active nav link
   */
  slice.call(document.querySelectorAll('.torch-nav a'), 0).forEach((field) => {
    let url = window.location.href
    let text = field.innerHTML.toLowerCase()
    let regex = RegExp(`\/${text}`)

    if (regex.test(url)) {
      field.classList.add('active')
    }
  })

  /*
   * Prevent empty fields from being submitted, since this breaks Filtrex.
   */
  const formFilters = document.querySelector('form#torch-filters-form')
  if (!formFilters) return

  formFilters.addEventListener('submit', function (e) {
    e.preventDefault()

    let disableFields = false

    slice.call(this.querySelectorAll('.field'), 0).forEach((field) => {
      let text = field.getElementsByTagName('label')[0].textContent
      let start = field.getElementsByClassName('start')[0]
      let end = field.getElementsByClassName('end')[0]

      if (start && end) {
        if (start.value === '' && end.value !== '') {
          window.alert(`Please select a start date for the ${text} field`)
          disableFields = true
        } else if (end.value === '' && start.value !== '') {
          window.alert(`Please select a end at date for the ${text} field`)
          disableFields = true
        }
      }
    })

    slice.call(this.querySelectorAll('input, select'), 0).forEach((field) => {
      if (field.value === '') {
        field.disabled = true
      }
    })

    if (!disableFields) {
      e.target.submit()
    }
  })

  slice.call(document.querySelectorAll('select.filter-type'), 0).forEach((field) => {
    field.addEventListener('change', (e) => {
      e.target.nextElementSibling.name = e.target.value
    })
  })

  slice.call(document.querySelectorAll('.datepicker'), 0).forEach((field) => {
    new Pikaday({field: field, theme: 'torch-datepicker'})
  })

  slice.call(document.querySelectorAll('.torch-flash-close'), 0).forEach((field) => {
    field.addEventListener('click', function (e) {
      let el = field
      let selector = 'torch-flash'
      while ((el = el.parentElement) && !((el.matches || el.matchesSelector).call(el, selector)))
      el.parentNode.removeChild(el)
    })
  })
}
