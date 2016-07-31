class MyThread extends Thread {

  int start, end;
  AtomicInteger state;

  public MyThread(int Start, int End) {
    start = Start;
    end = End;
    state = new AtomicInteger(0);
    
  }

  public void run() {
    if (state.get() == 0) {
      for (int i = start; i < end; ++i) {
        agents.get(i).update();
        agents.get(i).display();
      }
      state.set(1);
    }
  }
}