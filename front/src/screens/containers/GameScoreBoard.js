import { connect } from "react-redux";
import { withRouter } from 'react-router-dom'
import GameScoreBoard from "../components/GameScoreBoard";
import { fetchScoreboard } from "../../actions/scoreboard"

const mapStateToProps = ({ scoreboard: { scoreBoardList }, session: { token }}) => {
    return { scoreBoardList, token }
}

const mapDispatchToProps = (dispatch, { match: { params: { gameId }}}) => {
    return {
        fetchScoreBoard: () => dispatch(fetchScoreboard(gameId))
    }
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(GameScoreBoard))