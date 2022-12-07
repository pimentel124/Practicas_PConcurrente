import java.util.Random;
import java.util.concurrent.Semaphore;


public class Practica1 {
    public enum Estat {
        FORA, ESPERANT, DINS
    }
    static Random r = new Random();

    static final int MAX = 4;
    static final String[] noms = {"Joan", "Pere", "Anna", "Maria", "Josep", "Laura", "Lluis", "Marta", "Marc", "Pilar"};
    static final int alumnes = noms.length;
    static int comptador_alumnes = 0;
    static int rondes = 3;

    static Estat estat = Estat.FORA; //Estat del director
    static Semaphore sEntrada = new Semaphore(1);
    static Semaphore sSalida = new Semaphore(1);
    static Semaphore sRonda = new Semaphore(0);
    static Semaphore sContador = new Semaphore(1);

    public static void main(String[] args) throws InterruptedException {

        new Practica1().inici();

    }

    public void inici() throws InterruptedException {


        System.out.println("SIMULACIÓ DE LA SALA D'ESTUDI");
        System.out.println("Nombre total de estudiants: " + noms.length);
        System.out.println("Nombre màxim d'estudiants a la sala: " + MAX);

        //Inicializam els threads
        Thread[] threads = new Thread[alumnes + 1];
        int t = 0;

        threads[t] = new Thread(new Director(t));
        t++;

        for (String nom : noms) {
            threads[t] = new Thread(new Estudiant(nom));
            t++;
        }


        for (int i = 0; i < alumnes + 1; i++) {
            threads[i].start();
        }
        for (int i = 0; i < alumnes + 1; i++) {
            threads[i].join();
        }

    }

    private static class Director implements Runnable {
        private int id;

        public Director(int id) {
            this.id = id;
        }

        @Override
        public void run() {

            try {
                for (int i = 0; i < rondes; i++) {
                    sContador.acquire(); //Se emplea para que no entren mas alumnos mientras se hace el calculo
                    System.out.println("\tEl sr. Director comença la ronda");


                    if (comptador_alumnes == 0) {

                        System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");

                    } else {
                        if (comptador_alumnes < MAX) {
                            sContador.release();
                            estat = Estat.ESPERANT;
                            System.out.println("\tEl Director està esperant per entrar. No molesta als que estudien");
                            sRonda.acquire(alumnes); //Espera a que salgan

                            //sInOut.acquire(); //Espera a que no haya un alumno en movimiento


                        } else {
                            sEntrada.acquire();
                            sContador.release();

                            estat = Estat.DINS;
                            System.out.println("\tEl Director està dins la sala d'estudi: S'HA ACABAT LA FESTA!");
                            sRonda.acquire(alumnes);

                        }

                    }

                    System.out.println("\tEl Director acaba la ronda " + (i + 1) + " de "+ rondes);
                    sEntrada.release();
                    estat = Estat.FORA;
                    sRonda.release(alumnes);
                    sContador.release();

                    Thread.sleep(r.nextInt(500));

                }
            } catch (InterruptedException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }


        }
    }


    private static class Estudiant implements Runnable {
        private final String nom;

        public Estudiant(String nom) {
            this.nom = nom;
        }

        @Override
        public void run() {
            try {

                sRonda.acquire();
                sEntrada.acquire();
                sContador.acquire();

                comptador_alumnes++;


                System.out.println("L'estudiant " + this.nom + " entra a la sala. Total d'estudiants: " + comptador_alumnes);

                sEntrada.release();


                if (comptador_alumnes >= MAX){
                    System.out.println(this.nom + ": FESTA!!!");
                }else {
                    System.out.println(this.nom + " estudia");
                }
                sContador.release();
                Thread.sleep(r.nextInt(2000));
                sSalida.acquire();
                sContador.acquire();
                comptador_alumnes--;
                System.out.println("L'estudiant " + this.nom + " surt de la sala. Total d'estudiants: " + comptador_alumnes);

                sSalida.release();

                if (comptador_alumnes == 0) {


                    if (estat == Estat.ESPERANT) {
                        System.out.println(nom + ": ADEU Senyor Director, pot entrar si vol, no hi ha ningú");
                    }
                }
                sContador.release();
                sRonda.release();

            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

    }
}