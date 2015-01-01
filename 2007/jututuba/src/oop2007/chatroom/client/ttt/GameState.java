package oop2007.chatroom.client.ttt;

import oop2007.chatroom.client.ui.TicTacToeUI;

/**
 * 
 * 0 1 2
 * 3 4 5
 * 6 7 8
 */

public class GameState {
	public static final int TURN_OURS = 0;
	public static final int TURN_THEIRS = 1;
	
	public static final int STATE_OURS = 0;
	public static final int STATE_THEIRS = 1;
	public static final int STATE_EMPTY = 3;
	
	private int[] board;
	private int turn;
	private TicTacToeUI ticTacToeUI;
	
	public TicTacToeUI getTicTacToeUI() {
		return ticTacToeUI;
	}

	public void setTicTacToeUI(TicTacToeUI ticTacToeUI) {
		this.ticTacToeUI = ticTacToeUI;
	}

	public GameState(int[] board, int turn) {
		this.board = board;
		this.turn = turn;
	}
	
	public boolean weWon() {
		return (ours(board[0]) && ours(board[1]) && ours(board[2]))
		|| (ours(board[3]) && ours(board[4]) && ours(board[5]))
		|| (ours(board[6]) && ours(board[7]) && ours(board[8]))
		|| (ours(board[0]) && ours(board[3]) && ours(board[6]))
		|| (ours(board[1]) && ours(board[4]) && ours(board[7]))
		|| (ours(board[2]) && ours(board[5]) && ours(board[8]))
		|| (ours(board[0]) && ours(board[4]) && ours(board[8]))
		|| (ours(board[2]) && ours(board[4]) && ours(board[6]));
	}
	
	public boolean theyWon() {
		return (theirs(board[0]) && theirs(board[1]) && theirs(board[2]))
		|| (theirs(board[3]) && theirs(board[4]) && theirs(board[5]))
		|| (theirs(board[6]) && theirs(board[7]) && theirs(board[8]))
		|| (theirs(board[0]) && theirs(board[3]) && theirs(board[6]))
		|| (theirs(board[1]) && theirs(board[4]) && theirs(board[7]))
		|| (theirs(board[2]) && theirs(board[5]) && theirs(board[8]))
		|| (theirs(board[0]) && theirs(board[4]) && theirs(board[8]))
		|| (theirs(board[2]) && theirs(board[4]) && theirs(board[6]));
	}
	
	public boolean ours(int state) {
		return state == STATE_OURS;
	}
	
	public boolean theirs(int state) {
		return state == STATE_THEIRS;
	}
	
	public boolean isOurTurn() {
		return turn == TURN_OURS; 
	}
	
	public static int[] createEmptyBoard() {
		int[] board = new int[9];
		for (int i = 0; i < 9; i++) {
			board[i] = STATE_EMPTY;
		}
		return board;
	}
	
	public boolean isFree(int position) {
		return board[position] == STATE_EMPTY;
	}
	
	public void setState(int position, int state) {
		board[position] = state;
	}
	
	public void setTurn(int turn) {
		this.turn = turn;
	}
	
	public boolean isFilled() {
		for (int i = 0; i < 9; i++) {
			if (board[i] == STATE_EMPTY) {
				return false;
			}
		}
		
		return true;
	}
}
