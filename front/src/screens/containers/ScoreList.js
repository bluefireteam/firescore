import { connect } from "react-redux";
import { withRouter } from 'react-router-dom'
import ScoreList from "../components/ScoreList";

const mapStateToProps = ({ score: { scores, loading }}) => {
    return { scores, loading }
}

const mapDispatchToProps = dispatch => {
    return {
        fetchScores: uuid => {
            dispatch({type: "LOADING_SCORES"})

            fetch(`https://api.score.fireslime.xyz/scores/${uuid}?sortOrder=DESC`)
            .then(resp => {
                return resp.json()
            })
            .then(scores => {
                dispatch({type: "LOAD_SCORES", payload: { scores }})
            })
            .catch(error => {
                console.log("Fail to fetch scores", error)
            })
        }
    }
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ScoreList))