using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

public class Pause : MonoBehaviour
{
    public float timer;
    public bool ispuse;
    public bool guipuse;

    public GameObject Player;
    [System.Serializable]
    public class Position
    {
        public float x;
        public float y;
    }

    void Update()
    {
        Time.timeScale = timer;
        if (Input.GetKeyDown(KeyCode.Escape) && ispuse == false)
        {
            ispuse = true;
        }
        else if (Input.GetKeyDown(KeyCode.Escape) && ispuse == true)
        {
            ispuse = false;
        }
        if (ispuse == true)
        {
            timer = 0;
            guipuse = true;

        }
        else if (ispuse == false)
        {
            timer = 1f;
            guipuse = false;

        }
    }
    public void OnGUI()
    {
        if (guipuse == true)
        {
            Cursor.visible = true;// включаем отображение курсора
            if (GUI.Button(new Rect((float)(Screen.width / 2), (float)(Screen.height / 2) - 150f, 150f, 45f), "Продолжить"))
            {
                ispuse = false;
                timer = 0;
                Cursor.visible = false;
            }
            if (GUI.Button(new Rect((float)(Screen.width / 2), (float)(Screen.height / 2) - 100f, 150f, 45f), "Сохранить"))
            {
                Position position = new Position();
                position.x = Player.transform.position.x;
                position.y = Player.transform.position.y;

                if (!Directory.Exists(Application.dataPath + "/saves"))
                    Directory.CreateDirectory(Application.dataPath + "/saves");

                FileStream fs = new FileStream(Application.dataPath + "/saves/save.sm", FileMode.Create);
                BinaryFormatter formatter = new BinaryFormatter();
                formatter.Serialize(fs, position);
                fs.Close();
                Cursor.visible = false;
            }
            if (GUI.Button(new Rect((float)(Screen.width / 2), (float)(Screen.height / 2) - 50f, 150f, 45f), "Загрузить"))
            {
                if (File.Exists(Application.dataPath + "/saves/save.sm"))
                {
                    FileStream fs = new FileStream(Application.dataPath + "/saves/save.sm", FileMode.Open);
                    BinaryFormatter formatter = new BinaryFormatter();
                    try
                    {
                        Position pos = (Position)formatter.Deserialize(fs);
                        Player.transform.position = new Vector2(pos.x, pos.y);
                    }
                    catch (System.Exception e)
                    {
                        Debug.Log(e.Message);
                    }
                    finally
                    {
                        fs.Close();
                    }
                }
                else
                {
                    Application.Quit();
                }
                Cursor.visible = false;
            }
            if (GUI.Button(new Rect((float)(Screen.width / 2), (float)(Screen.height / 2), 150f, 45f), "В Меню"))
            {
                ispuse = false;
                timer = 0;
                Application.LoadLevel("Menu"); 
            }
        }
    }
}
