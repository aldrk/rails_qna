class Answer{
    constructor(){
        this.formEdit()
        this.bestAnswer()
        this.voteForm()
    }

    formEdit() {
        $('.answers').on('click', '.edit-answer-link', event => {
            const answerId = $(event.target).data('answerId')

            event.preventDefault();
            $(event.target).hide();
            $('form#edit-answer-' + answerId).removeClass('hidden')
        })
    }

    bestAnswer() {
        $('.answer').first().before($(".best-answer"))
    }

    voteLink(id, liked){
        let link = $(`<a class="voting ${liked ? 'upVote' : 'downVote'}">${liked ? 'Like' : 'Dislike'} this</a>`)

        link.attr('data-type', 'json')
        link.attr('data-remote', true)
        link.attr('rel', 'nofollow')
        link.attr('data-method', 'put')
        link.attr('href', `/answers/${id}/vote?liked=${liked}&amp`)
        link.on('ajax:success', event => { this.voteEvent(event) })

        return link
    }

    voteCancelLink(id){
        let link = $(`<a class="voting cancelVote"> Cancel vote</a>`)

        link.attr('data-type', 'json')
        link.attr('data-remote', true)
        link.attr('rel', 'nofollow')
        link.attr('data-method', 'delete')
        link.attr('href', `/answers/${id}/cancel_vote?votable_type=Answer`)
        link.on('ajax:success', event => { this.voteCancelEvent(event) })

        return link
    }

    voteEvent(event){
        const vote = event.detail[0]

        $(`#answer-${vote.id} .upVote`).remove()
        $(`#answer-${vote.id} .downVote`).replaceWith(this.voteCancelLink(vote.id))
    }

    voteCancelEvent(event){
        const vote = event.detail[0]

        $(`#answer-${vote.id} .cancelVote`)
            .replaceWith(this.voteLink(vote.id, true), this.voteLink(vote.id, false))
    }

    voteErrorEvent(event){
        const errors = event.detail[0]

        $('.answer-errors').text = ''

        errors.each((index, value) => {
            $('.answer-errors').append(`<p>${value}</p>`)
        })
    }

    voteForm() {
        $('.upVote')
            .on('ajax:success', event => { this.voteEvent(event) })
            .on('ajax:error', event => { this.voteErrorEvent(event) })
        $('.downVote')
            .on('ajax:success', event => { this.voteEvent(event) })
            .on('ajax:error', event => { this.voteErrorEvent(event) })
        $('.cancelVote')
            .on('ajax:success', event => { this.voteCancelEvent(event) })
            .on('ajax:error', event => { this.voteErrorEvent(event) })
    }

    static jsonRender(data){
        const locals = JSON.parse(data)

        const answer = $('<div></div>').toggleClass('answer').attr('id', `answer-${locals.answer.id}`)
        const voteCounter = $('<h3>0</h3>').toggleClass('vote-counter')
        const votes = $('<div></div>').toggleClass('votes').append(voteCounter)
        const comments = $('<div></div>').toggleClass('comments').append('<h5>Comments: </h5>')
        const newComment = $('<div></div>').toggleClass('new-comment')
        newComment.append(this.newComment(locals))

        answer
            .append(`<p>${locals.answer.title}</p>`)
            .append(`<p>${locals.answer.body}</p>`)
            .append(votes)
            .append(comments)
            .append(newComment)

        return answer
    }

    static newComment(locals){
        const form = $('<form></form>')
        const token = $('<input></input>')

        form.attr({
            action: `/answers/${locals.answer.id}/comments.js`,
            'accept-charset': 'UTF-8',
            'data-remote': true,
            method: 'post'
        })

        token.attr({
            type: 'hide',
            name: 'authenticity_token',
            value: locals.create_comment_token
        }).hide()

        form
            .append(token)
            .append($('<label for="comment_body">Comment:</label>'))
            .append($('<textarea></textarea>').attr({
                name: 'comment[body]',
                id: 'comment_body'
            }))
            .append($('<input></input>').attr({
                type: 'submit',
                name: 'commit',
                value: 'Comment',
                'data-disable-with': 'Comment'
            }))

        return form
    }
}

export default Answer