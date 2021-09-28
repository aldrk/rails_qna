class Question {
    constructor() {
        this.formEdit()
        this.voteForm()
    }

    formEdit() {
        $('.questions').on('click', '.edit-question-link', event => {
            const questionId = $(event.target).data('questionId')

            event.preventDefault();
            $(event.target).hide();
            $('form#edit-question-' + questionId).removeClass('hidden')
        })
    }

    voteLink(id, liked) {
        let link = $(`<a class="voting ${liked ? 'upVote' : 'downVote'}">${liked ? 'Like' : 'Dislike'} this</a>`)

        link.attr('data-type', 'json')
        link.attr('data-remote', true)
        link.attr('rel', 'nofollow')
        link.attr('data-method', 'put')
        link.attr('href', `/questions/${id}/vote?liked=${liked}&amp`)
        link.on('ajax:success', event => {
            this.voteEvent(event)
        })

        return link
    }

    voteCancelLink(id) {
        let link = $(`<a class="voting cancelVote"> Cancel vote</a>`)

        link.attr('data-type', 'json')
        link.attr('data-remote', true)
        link.attr('rel', 'nofollow')
        link.attr('data-method', 'delete')
        link.attr('href', `/questions/${id}/cancel_vote?votable_type=Question`)
        link.on('ajax:success', event => {
            this.voteCancelEvent(event)
        })

        return link
    }

    voteEvent(event) {
        const vote = event.detail[0]

        $(`#question-${vote.id} .upVote`).remove()
        $(`#question-${vote.id} .downVote`).replaceWith(this.voteCancelLink(vote.id))
    }

    voteCancelEvent(event) {
        const vote = event.detail[0]

        $(`#question-${vote.id} .cancelVote`)
            .replaceWith(this.voteLink(vote.id, true), this.voteLink(vote.id, false))
    }

    voteErrorEvent(event) {
        const errors = event.detail[0]

        $('.question-errors').text = ''

        errors.each((index, value) => {
            $('.question-errors').append(`<p>${value}</p>`)
        })
    }

    voteForm() {
        $('.upVote')
            .on('ajax:success', event => {
                this.voteEvent(event)
            })
            .on('ajax:error', event => {
                this.voteErrorEvent(event)
            })
        $('.downVote')
            .on('ajax:success', event => {
                this.voteEvent(event)
            })
            .on('ajax:error', event => {
                this.voteErrorEvent(event)
            })
        $('.cancelVote')
            .on('ajax:success', event => {
                this.voteCancelEvent(event)
            })
            .on('ajax:error', event => {
                this.voteErrorEvent(event)
            })
    }
}

export default Question