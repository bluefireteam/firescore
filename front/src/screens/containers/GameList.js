import { connect } from "react-redux";
import { withRouter } from 'react-router-dom'
import GameList from "../components/GameList";
import { fetchGames } from "../../actions/game"

const mapStateToProps = ({ games: { gameList }, session: { token }}) => {
    return { gameList, token }
}

const mapDispatchToProps = (dispatch) => {
    return {
        fetchGames: () => dispatch(fetchGames())
    }
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(GameList))