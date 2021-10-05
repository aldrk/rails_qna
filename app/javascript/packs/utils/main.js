import Answer from '../entities/Answer'
import Question from '../entities/Question'
import Comment from "../entities/Comment";

$(document).on('turbolinks:load', () => {
    new Answer()
    new Question()
    new Comment()
})
