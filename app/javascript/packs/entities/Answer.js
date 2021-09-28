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
}

export default Answer