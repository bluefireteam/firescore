import { connect } from "react-redux";
import SearchForm from "../components/SearchForm";

const mapStateToProps = (state) => {
    return { uuid: state.uuid, loading: state.loading }
}

const mapDispatchToProps = (dispatch) => {
    return {
        fetchScores: (uuid) => {
            dispatch({type: "LOADING_SCORES"})

            fetch(`https://api.score.fireslime.xyz/scores/${uuid}?sortOrder=DESC`)
            .then((resp) => {
                return resp.json()
            })
            .then((scores) => {
                dispatch({type: "LOAD_SCORES", payload: { scores }})
            })
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(SearchForm)