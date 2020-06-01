import Pikaday from 'pikaday'

// Phoenix html copied here since I ran into extensive issues trying to import
// from the dep.
;(function () {
  function buildHiddenInput (name, value) {
    const input = document.createElement('input')
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

    const method = buildHiddenInput('_method', link.getAttribute('data-method'))
    const csrf = buildHiddenInput('_csrf_token', link.getAttribute('data-csrf'))
    const form = document.createElement('form')

    form.method = (link.getAttribute('data-method') === 'get') ? 'get' : 'post'
    form.action = link.getAttribute('data-to')
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
    const url = window.location.href
    const linkTarget = field.getAttribute('href')
    const regex = RegExp(linkTarget)

    if (regex.test(url)) {
      field.classList.add('active')
    }
  })

  /*
   * Flash Messages
   */
  slice.call(document.querySelectorAll('button.torch-flash-close'), 0).forEach((button) => {
    button.addEventListener('click', function () {
      const flashMessage = button.closest('.torch-flash')
      flashMessage.parentNode.removeChild(flashMessage)
    })
  })

  /*
   * Prevent empty fields from being submitted, since this breaks Filtrex.
   */
  const formFilters = document.querySelector('form#torch-filters-form')
  if (!formFilters) return

  formFilters.addEventListener('submit', function (e) {
    e.preventDefault()

    let canSubmit = true

    slice.call(this.querySelectorAll('.field'), 0).forEach((field) => {
      const text = field.getElementsByTagName('label')[0].textContent
      const start = field.getElementsByClassName('start')[0]
      const end = field.getElementsByClassName('end')[0]

      if (start && end) {
        if (start.value === '' && end.value !== '') {
          window.alert(`Please select a start date for the ${text} field`)
          canSubmit = false
        } else if (end.value === '' && start.value !== '') {
          window.alert(`Please select an end at date for the ${text} field`)
          canSubmit = false
        }
      }
    })

    if (canSubmit) {
      slice.call(this.querySelectorAll('input, select'), 0).forEach((field) => {
        if (field.value === '') {
          field.disabled = true
        }
      })

      e.target.submit()
    }
  })

  slice.call(document.querySelectorAll('select.filter-type'), 0).forEach((field) => {
    field.addEventListener('change', (e) => {
      e.target.nextElementSibling.name = e.target.value
    })
  })

  const formatDate = date =>
    date
      .toLocaleString('en-us', { year: 'numeric', month: '2-digit', day: '2-digit' })
      .replace(/(\d+)\/(\d+)\/(\d+)/, '$3-$1-$2')

  /* eslint-disable no-new */
  slice.call(document.querySelectorAll('.datepicker'), 0).forEach((field) => {
    new Pikaday({
      field: field,
      toString: date => formatDate(date),
      onSelect: date => (field.value = formatDate(date)),
      theme: 'torch-datepicker'
    })
  })
  /* eslint-enable no-new */

  slice.call(document.querySelectorAll('.torch-flash-close'), 0).forEach((field) => {
    field.addEventListener('click', function (e) {
      let el = field
      const selector = 'torch-flash'
      while ((el = el.parentElement) && !((el.matches || el.matchesSelector).call(el, selector))) { el.parentNode.removeChild(el) }
    })
  })
}
