class Question{
    constructor(){
        this.formEdit()
    }

    formEdit() {
        $('.questions').on('click', '.edit-question-link', eveny => {
            const questionId = $(eveny.target).data('questionId')

            eveny.preventDefault();
            $(eveny.target).hide();
            $('form#edit-question-' + questionId).removeClass('hidden')
        })
    }
}

export default Question