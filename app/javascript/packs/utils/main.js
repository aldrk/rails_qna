import Answer from '../entities/Answer'
import Question from '../entities/Question'

$(document).on('turbolinks:load', () => {
    new Answer()
    new Question()
})
